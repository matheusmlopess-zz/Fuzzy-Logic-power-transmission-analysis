function [V_th, tabela2, tabela_pot, J, delta_Ds, delta_Z, Xctr, delta_X, X, Ybus,desvios_pot_act ,desvios_pot_react , dP_dV, d_1, d_2, J_12, delta_Pik, delta_Qik, S, S2]= transito_difuso(n)

cn=[
    0	0	0	0	0	0	17	20	22	3	5	7 
    0	0	0	0	0	0	54	60	67	20	25	30
    0	0	0	0	0	0	38	40	45	12	15	17
    143	150	155	0	0	0	25	30	31	12	15	18
    0	0	0	0	0	0	95	100	106	35	40	46];
%     disp(cn)
    cn=cn/100; % *passando para pu
%----------------------------------------------------------------------------------------------------------%
% Variaveis simbolicas usadas para a resolução do trasito de potência difuso
% syms V theta tabela tabela2 tabela_pot Jinv Pinj Qinj Aux desvios  desvios2 desvios_1  desvios_2 Xctrs delta_X 
 syms  J_12 Bik_V S S2 d_1 d_2

%----------------------------------------------------------------------------------------------------------%
%Função da Biblioteca de funções do Matpower usada para o calculo do transtito de potencia   
% Determinação da matriz de elementos centrais apartir do transito de potências Metodo Newton (NR)
mpc = loadcase('rede5barr');              %Carrega a folha de especificações da rede de 5 barramentos do trabalho 
mpopt = mpoption( 'out.all',0,'verbose',0,'out.force',0);

results= runopf(mpc,mpopt);               % results recebe os resultados armazenados na struct's geradas pelas funções do MatPower 
%O resultado do transito de potencia nos permite determinar: valores centrais(V e thetas nos barramentos para o cenario de rede fornecido);
V_th=results.bus(:,8);                  %tensões em Pu
V_th(:,2)=results.bus(:,9)*(pi/180);    %angulos em radianos
V_th(:,3)=results.bus(:,8)*150;         %tensões em KV
V_th(:,4)=results.bus(:,4);             %consumo ativo
V_th(:,5)=results.bus(:,3);             %consumo reativo
tabela2=results.gen(:,2);                 %geração ativa
tabela2(:,2)=results.gen(:,3) ;           %geração reactiva 
tabela_pot=results.branch(:,14);              %transito de potencia ativa Pik
tabela_pot(:,2)=results.branch(:,15);         %transito de potencia reativa Qik
tabela_pot(:,3)=results.branch(:,16);         %transito de potencia ativa Pki
tabela_pot(:,4)=results.branch(:,17);         %transito de potencia reativa Qki
tabela_pot(:,5)=real(get_losses(results));    %Perdas attivas
tabela_pot(:,6)=imag(get_losses(results));    %perdas reactivas


%---------------------------------------------------------------------------------------%
% cprintf('blue','O jacobiano resultado do transito de potencia é :');  
%    J = makeJac(mpc);
%    J=full(J)     % converte notação sparse complex para notação matriz 
J=[  24.52	-8.49	0	-5.32	10.58	-5.52	-1.65;  -8.57	16.91	-8.34	0	-5.42	8.43	0;    0	-8.63	17.16	-8.53	0	-3.11	-2.93;    -5.28	0	-8.1	16.16	-1.78	0	4.74;    -11.49	5.39	0	1.58	24.69	-8.71	-5.56;    5.27	-9.03	3.75	0	-8.81	17.02	0;    1.73	0	3.85	-6.53	-5.42	0	16.05];
% função do Matpower que retorna o Jacobiano da rede usada para o calculo do transito de potência 
                
  Jinv=inv(J);                 % *invertendo o Jacobiano

%---------------------------------------------------------------------------------------%
  %Determinação de um vetor com os Potencias injetadas centrais e difusas 
    format shortG
    for i=1:1:5                           
           for k=1:1:3
    Qinj(i,4-k)=cn(i,7-k)-cn(i,9+k);    %Determinação Potencias Reativas difusas
    Pinj(i,k)=cn(i,k)-cn(i,10-k);       %Determinação Potencias Ativas difusas
       end
    end
    Pinj=double(Pinj);  %converte vetor symbol para double 
    Qinj=double(Qinj);  %converte vetor symbol para double
                        
Qinj = Qinj(~ismember(1:size(Qinj,1),1),:); Qinj = Qinj(~ismember(1:size(Qinj,1),3),:); % elimina barramentos PV de Referencia      
Pinj = Pinj(~ismember(1:size(Pinj,1),1),:) ;       % elimina a linha do barramento de referencia

delta_Ds=[ Pinj; Qinj];   % *Retorna o vetor concatendo das potências (P's e Q's) centrais e difusas da rede

%---------------------------------------------------------------------------------------%
% Delta_Z - determinaçã da matriz  potências injetadas Delta_Z difusas  e centrais 
% [Delta_Zmin] limites inferiores da variável difusa e [Delta_Zmax] limites superiores da variável difusa
 desvios =-(Pinj(:,2)-Pinj(:,1));       % [Delta_Zmin]( P )
 desvios2=-(Pinj(:,2)-Pinj(:,3));       % [Delta_Zmax]( P )
 desvios_1=-(Qinj(:,2)-Qinj(:,1));      % [Delta_Zmin]( Q )
 desvios_2=-(Qinj(:,2)-Qinj(:,3));      % [Delta_Zmax]( Q )
  x=[desvios; desvios_1];               % concatena matrizes inferires
  y=[desvios2; desvios_2];              % concatena matrizes superiores
  delta_Z= x;  delta_Z(:,3)= y;          % *Retorna a matriz de desvios Delta_z
  
%---------------------------------------------------------------------------------------%
%   Matriz dos Desvios das variaveis de Xctr (p.u.)
Xctr=V_th(:,2);                      % determina se a matriz dos Xctrs armazena valores centrais
Xctr=Xctr(~ismember(1:size(Xctr),1),1);  Aux=V_th(:,1);                % elimina o barramento de referecia da matriz coluna das tensões 
Aux=Aux(~ismember(1:size(Aux),1),1) ;  Aux=Aux(~ismember(1:size(Aux),3),1) ;   % elimina o barramento de PV e Ref da matriz coluna dos thetas %
Xctr= [Xctr; Aux];    %*Retorna a matriz Variaveis de Xctrs do sistema (p.u.) 

Aux=Jinv;   Aux(Jinv<0)=0;        %[J(-)]-1 valores negativos da matiz Jacobiana
Aux2=Jinv;     Aux2(Jinv>0)=0;          %[J(+)]-1 valores positivos da matiz Jacobiana
delta_X = Aux*delta_Z+Aux2*delta_Z;     % *Retorna a matriz de desvios da variavel de Xctr Delta_X~ 
%---------------------------------------------------------------------------------------%
% Determinção das Fases e tensões difuzas (p.u.)
 X=delta_X;
 X(:,2)=Xctr;              %X recebe os valores centrais
 X(:,1) =X(:,2)+(X(:,1));   % faz se Xctr + Delta_X~
 X(:,3) =X(:,2)+X(:,3);   % *Retorna X~
 format shortG
%---------------------------------------------------------------------------------------%
 % Matriz de admitâncias
  [Ybus] = makeYbus(mpc); %formação da matriz de admitancias
  Ybus=full(Ybus);  % converte notação sparse complex para notação matriz 
  G=real(Ybus);     %*Matriz de condutâncias usada para o calculo de S_Pik
  B=imag(Ybus);     %*Matriz de suceptâncias usada para o calculo de S_Qik
 
%---------------------------------------------------------------------------------------%
% Determinação das matrizes de sensibilidades para a potência ativa e para a reativa S_Pik e S_Qik
% Determinação do sentido do transito de potêmcia dada pelo inteiro  exigido 'ik_ki' na entrada da função 
 
if n==1
I=mpc.branch(:,1); K=mpc.branch(:,2);   %Determina se Barramentos de origens i's e Barr. de destino k's
dP_dV=I(:,1); dP_dV(:,2)=K;             %Matriz de Barramentos de origens e destinos - ik 
% dP_dVi=-2* Gik* Vi+ Vk*(Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k));
else
K=mpc.branch(:,1); I=mpc.branch(:,2);   %Determina se Barramentos de origens i's e Barr. de destino k's
dP_dV=I(:,1); dP_dV(:,2)=K;             %Matriz de Barramentos de origens e destinos - ik 
% dP_dVi=-2* Gik* Vi+ Vk*(Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k));
end

% dP_dVk= Vi*(Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k));
% dP_dVthi=Vi*Vk*(-Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k));
% dP_dVthi=-(Vi*Vk*(-Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k)));
 for i=1:1:size(mpc.branch)
       dP_dVi(i,1)=-2* G(I(i),K(i))* V_th(I(i),1)+ V_th(K(i),1)*( G(I(i),K(i))*cos((V_th(I(i),2)-V_th(K(i),2)))+B(I(i),K(i))*sin((V_th(I(i),2)-V_th(K(i),2))));
       dP_dVk(i,1)=V_th(I(i),1)*( G(I(i),K(i))*cos( V_th(I(i),2)-V_th(K(i),2))+B(I(i),K(i))*sin( V_th(I(i),2)-V_th(K(i),2)));  
       dP_dthi(i,1)=V_th(I(i),1)*V_th(K(i),1)*( -G(I(i),K(i))*sin(V_th(I(i),2)-V_th(K(i),2))+B(I(i),K(i))*cos(V_th(I(i),2)-V_th(K(i),2)));
 end
 dP_dthk=dP_dthi;
 dP_dthk(:,1)=-dP_dthk(:,1);
 d_1 = [dP_dVi dP_dVk dP_dthi dP_dthk];    %*Retorna matriz com as derivadas parciais da potência ativa
 
% dP_dVi=2* Gik* Vi+ Vk*(Gik*sin(theta_i-theta_k)-Bik*cos(theta_i-theta_k));
% dP_dVk= Vi*(Gik*sin(theta_i-theta_k)-Bik*cos(theta_i-theta_k));
% dP_dVthi=Vi*Vk*(Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k));
% dP_dVthi=-(Vi*Vk*(-Gik*cos(theta_i-theta_k)+Bik*sin(theta_i-theta_k)));
 for i=1:1:size(mpc.branch)
       dQ_dVi(i,1)=2* B(I(i),K(i))* V_th(I(i),1)+ V_th(K(i),1)*( G(I(i),K(i))*sin((V_th(I(i),2)-V_th(K(i),2)))-B(I(i),K(i))*cos((V_th(I(i),2)-V_th(K(i),2))));
       dQ_dVk(i,1)=V_th(I(i),1)*( G(I(i),K(i))*sin( V_th(I(i),2)-V_th(K(i),2))-B(I(i),K(i))*cos( V_th(I(i),2)-V_th(K(i),2)));  
       dQ_dthi(i,1)=V_th(I(i),1)*V_th(K(i),1)*( G(I(i),K(i))*cos(V_th(I(i),2)-V_th(K(i),2))+B(I(i),K(i))*sin(V_th(I(i),2)-V_th(K(i),2)));
 end
  dQ_dQthk=dQ_dthi;
  dQ_dQthk(:,1)=-dQ_dQthk(:,1);
  
d_2 = [dQ_dVi dQ_dVk dQ_dthi dQ_dQthk];    %*Retorna matriz com as derivadas parciais da potência reativa
%----------------------------------------------------------------------------------------------------------
% determinação da matriz de sensibilidades
J_12=[]; k=[0 1 2 3 4 0 5 6 0 7];S=[]; Bik_V =[]; S2 =[];
  for i=1:1:10
     if k(i)~=0
        J_12(i,:)=Jinv(k(i),:);
     end
  end
    K=mpc.branch(:,1); I=mpc.branch(:,2);
  for i=1:1:size(I)                      %Forma matriz [J^(-1)]V/theta_i/k....
        Bik_V(2,:)=J_12(I(i)+5,:);
        Bik_V(1,:)=J_12(K(i)+5,:);
        Bik_V(4,:)=J_12(I(i),:);
        Bik_V(3,:)=J_12(K(i),:);
            S(i,:)  = d_1(i,:)*Bik_V;     %*Retorna matriz de sensibilidades para as potências ativas - sentido ik
            S2(i,:) = d_2(i,:)*Bik_V;     %*Retorna matriz de sensibilidades para as potências reativas - sentido ik
          
%             disp( Bik_V)                 %* Retorna Matriz [J^(-1)]V/theta_i/ka... 
  end
  
  aux=S; aux2=S; aux(S>0)=0; aux2(S<0)=0;            % Filtra valores positivos negativos e determina martrizs sensibilidadesMW (+) & (-)
  delta_Pik=aux2*delta_Z(:,1)+aux*delta_Z(:,3);      %Gera matriz dos desvios da potência ativa
  delta_Pik(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3); %Gera matriz dos desvios da potência ativa
  desvios_pot_act=delta_Pik;                        %*Retorna matriz dos desvios da potência ativa
 delta_Pik(:,2)=tabela_pot(:,1)/100     ;           % Matriz de desvios recebe os valores centrais
 delta_Pik(:,1) =delta_Pik(:,2)+delta_Pik(:,1);     % Gera os resultados difusos faz se Pik_ctr + Delta_Pik~
 delta_Pik(:,3) =delta_Pik(:,2)+delta_Pik(:,3);     %*Retorna Pik~
   
  aux=S2; aux2=S2; aux(S2>0)=0; aux2(S2<0)=0;     % Filtra valores positivos negativos e determina martrizs sensibilidadesMVar(+) & (-)  
  delta_Qik=aux2*delta_Z(:,1)+aux*delta_Z(:,3);   % Gera matriz dos desvios da potência reativa
  delta_Qik(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3); % Gera matriz dos desvios da potência reativa
  desvios_pot_react=delta_Qik;                       %*Retorna matriz dos desvios da potência reativa
 delta_Qik(:,2) = tabela_pot(:,2)/100 ;              %delta_Pik recebe os valores centrais
 delta_Qik(:,1) = delta_Qik(:,2)+delta_Qik(:,1);     % faz se Pikcentral + delta_Qik~
 delta_Qik(:,3) = delta_Qik(:,2)+delta_Qik(:,3);     % *Retorna Qik~
  
 end

