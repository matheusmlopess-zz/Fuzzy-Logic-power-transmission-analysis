clc
clear all
format shortG

cprintf('blue','Trabalho I - DOIC \n\n'); 
cprintf('red','Matheus Macedo Lopes \n'); 
cprintf('red','Tiago Daniel Oliveira Pinto \n'); 

cprintf('blue','                           Caracteristicas da Linha              \n\n'); 
cprintf('blue','----------------------------------------------------------------------- \n\n'); 
fprintf('           doB1       paraB2        R             X      Ysh=Y/2=0.02  \n');
    s=[[1 2 0.03 0.08 0];[1 5 0.09 0.32 0];[2 3 0.05 0.08 0];[2 5 0.05 0.16 0];[3 4 0.04 0.10 0];[4 5 0.04 0.10 0]];
    disp(s);
cprintf('blue','              Classificação dos barramentos da Rede para o trabalho 1     \n\n'); 
cprintf('blue','-------------------------------------------------------------------------------- \n\n'); 

fprintf('  Pga   Pgb   Pgc    Qga   Qgb   Qgc   Pca   Pcb   Pcc   Qca   Qcb    Qcc  \n')
fprintf('   MW    MW    MW   Mvar   Mvar  Mvar  MW    MW    MW    Mvar  Mvar   Mvar \n')

cn=[
    0	0	0	0	0	0	17	20	22	3	5	7 
    0	0	0	0	0	0	54	60	67	20	25	30
    0	0	0	0	0	0	38	40	45	12	15	17
    143	150	155	0	0	0	25	30	31	12	15	18
    0	0	0	0	0	0	95	100	106	35	40	46];
%     disp(cn)
    cn=cn/100; % *passando para pu

    cprintf('blue','-------------------------------------------------------------------------------- \n\n'); 
    format short
   % Fromação da Matriz de Susceptância [B]
    linhainfo = s;
    DE_B = linhainfo(:,1);       % Vetor de barramentos de origem...
    PARA_B = linhainfo(:,2);     % Vetor de barramentos de destino...
    r = linhainfo(:,3);          % Vetor de Resistencias, R...
    x = linhainfo(:,4);          % Vetor de Rtancias, X...
    b = linhainfo(:,5);          % Vetor de Adimitancia de terra, B/2...

    z = x;                       % Z (matriz)...
    y = 1./z;                    % inverte os elementos de Z...
  
    nbarramento = max(max(DE_B),max(PARA_B));            % no. de barramentos...
    n_no = length(DE_B);                                 % no. nós...
    ybarramento = zeros(nbarramento,nbarramento);        % inicializa o ybarramento...

 % Fomação do triangulo inferior e superior da matriz de susceptância ...
    
for k=1:n_no
     ybarramento(DE_B(k),PARA_B(k)) = -y(k);                                %analiza posição dos vectores nos barramentos
     ybarramento(PARA_B(k),DE_B(k)) = ybarramento(DE_B(k),PARA_B(k));       %preenche o valor anterior na posição simetrica da matriz
 end
 % Formação da diagonal principal...
 for m=1:nbarramento
     for n=1:n_no
         if DE_B(n) == m || PARA_B(n) == m
             ybarramento(m,m) = ybarramento(m,m) + y(n) + b(n);
         end
     end
 end
 
  cprintf('blue','               Matriz de Susceptância [B]                 \n\n');
	disp(ybarramento);

  cprintf('blue','               Matriz inversa [B] - Impedâncias       \n\n');
	f=1;   
	m = ybarramento(~ismember(1:size(ybarramento, 1), [f,0]), :);

 cprintf('blue','  eliminando linhas e coluna do barramento de referencia da matriz [B] obtemos :::        \n\n'); 
	ybarramento(:, f)=[];
	m = ybarramento(~ismember(1:size(ybarramento, 1), f), :);
	disp(m);

cprintf('blue',' invertendo [B] obtemos [B]^-1 =        \n\n'); 
	m=inv(m);
	disp(m);

cprintf('blue','             Aplicando o metodo Fuzzy para determinar os desvios das potências injetadas [B]        \n\n');


%------------------------------------------------------------------------------ 
    for i=1:1:5                           
       for k=1:1:3
         Pinj(i,k)=cn(i,k)-cn(i,10-k);       %Determinação Potencias Ativas difusas
       end
    end
    Pinj=double(Pinj);  %converte vetor symbol para double 
   
                      
Pinj = Pinj(~ismember(1:size(Pinj,1),1),:)        % elimina a linha do barramento de referencia
%---------------------------------------------------------------------------------------%

 Desvios_Pinj(:,1) =-(Pinj(:,2)-Pinj(:,1));   
 Desvios_Pinj(:,3) =-(Pinj(:,2)-Pinj(:,3))  %retorna os desvios de potencia
 
 cprintf('blue','     Obtenção dos desvios dos Thetas        \n\n');
 matriz_thetas=m*Pinj    %determina a matriz dos thetas
 
 
          
cprintf('blue','Desvios dos thetas Barr 2-5\nFase   a          b       c \n');
  Desvios_theta=m*Desvios_Pinj;
  disp(Desvios_theta)  
  
cprintf('blue','Valores dos thetas = Theta + Desvios de Theta    \n');

  for i=1:1:4
  theta_linha(i,:)=Desvios_theta(i,:)+matriz_thetas(i,2);
  end
theta_linha
 
cprintf('blue','Matriz que relaciona a potência injectada em i com a potência injectada barramento no j \n\n')
	


cprintf('red','                         Matriz de sensibilidade da rede \n\n')
	ordem=DE_B(:,1);        %add a matriz ordem a coluna dos barramentos de origem
    ordem(:,2)=PARA_B;      %add a matriz ordem a coluna dos barramentos de destino 
  	s=ordem;                %add a matriz sensibilidade as coluna dos barramentos de origem e destino 

  % formação da matriz sensibilidades pelo metodo difuso
    format shortG
for i=1:1:size(m)
sensibilidade(1,i)=(0-m(1,i)/x(1));
sensibilidade(2,i)=(0-m(4,i)/x(2));
sensibilidade(3,i)=(m(1,i)-m(2,i))/x(3);
sensibilidade(4,i)=((m(1,i)-m(4,i))/x(4));    %artificio usado para correção do sinal na matrix de sensibilidades (alterar a ordem na subtrção)
sensibilidade(5,i)=((m(2,i)-m(3,i))/x(5));
sensibilidade(6,i)=((m(3,i)-m(4,i))/x(6));
end
sensibilidade=double(sensibilidade);
fprintf('           doB1       paraB2        B2             B3          B4       B5   \n');
u=[s sensibilidade];    % concatena horizontalmente as matrizes snsibilidade com a matiz dos barramentos de origem e destino 
disp(u);

PL_central=sensibilidade*Pinj(:,2)

cprintf('blue','Matriz sensibilidade (-) \n\n');
U=sensibilidade;         
U(sensibilidade>0)=0 ;    %[J(-)]-1 valores negativos da matiz Jacobiana
disp(U)
cprintf('blue','Matriz sensibilidade (+) \n\n');
Z=sensibilidade;   
Z(sensibilidade<0)=0 ;    %[J(+)]-1 valores positivos da matiz Jacobiana
disp(Z)

  delta_PL(:,1) = Z*Desvios_Pinj(:,1)+U*Desvios_Pinj(:,3);
  delta_PL(:,3) = Z*Desvios_Pinj(:,3)+U*Desvios_Pinj(:,1)

  cprintf('blue','Matriz PL = Desvios PL + PL_central ) \n');
  
  for i=1:1:6
  PL_linha(i,:)=PL_central(i)+delta_PL(i,:);  % calcula PL apartir dos desvios 
  end

PL_linha   %*Retorna a matriz de Potencias injetadas difusas
  
 

