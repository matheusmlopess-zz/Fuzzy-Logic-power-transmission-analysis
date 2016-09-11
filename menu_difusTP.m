%funções que inicializa o menu grafico
function varargout = menu_difusTP(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @menu_difusTP_OpeningFcn, ...
                   'gui_OutputFcn',  @menu_difusTP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
          
 if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function varargout = menu_difusTP_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tabela2_CellEditCallback(hObject, eventdata, handles)


function axes1_CreateFcn(hObject, eventdata, handles)


function tabela1_CellEditCallback(hObject, eventdata, handles)


function listbox2_KeyPressFcn(hObject, eventdata, handles)
 
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%função que determina o sentido do transito de potencia 
function pushbutton1_Callback(hObject, eventdata, handles)
close all   % função do botão sair


function menu_difusTP_OpeningFcn(hObject, eventdata, handles, varargin)
 handles.output = hObject;   
 guidata(hObject, handles);    %chama a figura da rede
 caminho=pwd
 path(path,caminho)
 strmatpower='\matpower5.1';  %adiciona ao path a pasta ond o programa foi descompactado
 caminho=strcat(caminho,strmatpower)   
 path(path,caminho)   %add ao path as bibliotecas usadas

function setGlobalx(valor)
global variavel_global
variavel_global = valor
function ty = getGlobalx
global variavel_global
ty = variavel_global;

%lista que determina sentido do transito de potencia difuso
function listbox1_Callback(hObject, eventdata, handles)
    filename='rede.bmp';
    h=imread(filename);
    image(h);
   
   
   sentido_do_transito=get(hObject,'value')
   setGlobalx(sentido_do_transito)
    
%lista que retorna os resultados do transito de potencia difuso no sentido selecionado
function listbox2_Callback(hObject, eventdata, handles)
         
ik_ki= getGlobalx  %recebe o sentido do TP
posicao=get(hObject,'Value')
conteudo=get(hObject,'String');

   [V_th, tabela2, tabela_pot, J, delta_Ds, delta_Z, Xctr, delta_X, X, Ybus,desvios_pot_act ,desvios_pot_react , dP_dV, d_1, d_2, J_12, delta_Pik, delta_Qik, S, S2] =transito_difuso(ik_ki);
 
% retorna tabelas a zero quando não chamadas
   in_hor ={' ',' ',' ',' ',' ',' ',' '}
   in_vert={' ',' ',' ',' ',' ',' ',' '}
   inicia=zeros(7)

    set(handles.tabela1,'ColumnName',in_hor);
    set(handles.tabela1,'RowName',in_vert);
    set(handles.tabela1,'Data',inicia);
    
    set(handles.tabela2,'ColumnName',in_hor);
    set(handles.tabela2,'RowName',in_vert);
    set(handles.tabela2,'Data',inicia);
%      Preenche tabelas tabelas a zero quando não chamadas
  if ik_ki ==1   %      Preenche tabelas referentes ao transito no sentido ik
         

     switch posicao
            case 1
      texto= {'TABELA I - Barramentos (pu)' 'NB: O segundo índice (a, b, c) assinala os três valores caraterísticos de cada número triangular '};
                cn=[
    0	0	0	0	0	0	17	20	22	3	5	7 
    0	0	0	0	0	0	54	60	67	20	25	30
    0	0	0	0	0	0	38	40	45	12	15	17
    143	150	155	0	0	0	25	30	31	12	15	18
    0	0	0	0	0	0	95	100	106	35	40	46];
    cn=cn/100; % *passando para pu
              cnames = {'Pga', 'Pgb', 'Pgc', 'Qga', 'Qgb', 'Qgc', 'Pca', 'Pcb', 'Pcc', 'Qca', 'Qcb', 'Qcc'};
              dnames = {'B1' 'B2' 'B3' 'B4' 'B5' };
               set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',cn);
              set(handles.text2,'String',texto);
            case 2
      texto = {'O resultado do trânsito de potência nos permite determinar:'  'valores centrais(V e thetas nos barramentos para o cenario de rede fornecido'};
      
              cnames = {'Tensões(pu)','Ângulos(rad)','Tensões(KV)','consumoPW','consumoVar'};
              dnames = {'Barr_1', 'Barr_2', 'Barr_3', 'Barr_4', 'Barr_5'};
        
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',V_th);
              set(handles.text1,'String',texto);
         
            case 3 
              texto = {'Geração nos barramentos de Referencia e PV'  };
              
              cnames = {'geração MW' 'geração Var'};
              dnames = {'Ger_B11', 'Ger_B12', 'Ger_B41', 'Ger_B42'};
        
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',tabela2 );
              set(handles.text1,'String',texto);
             
            case 4
            
            
              texto = {'Resultado do trânsito de potência no sentido  ' '- valores centrais i-k  k-i'};
              cnames = {'P_ik','Q_ik','P_ki','Q_ki','Perdas PW','perdas Var'};
              dnames = {'B1_2_1', 'B1_5_1', 'B2_3_1', 'B2_5_2','B3_4_3','B4_5_4'};
        
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',tabela2 );
              set(handles.text1,'String',texto);
            
                set(handles.tabela1,'Data',tabela_pot);
            case 5   
              texto = {'Potências injetadas, valores centrais e difusos.'};
                     
              dnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',delta_Ds);
            case 6 
              texto = {'Desvios das potências injetadas (p.u.)'};
                         
              dnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',delta_Z);
            case 7
              texto = {'Matriz Jacobiana ' };
              dnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              cnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',J);
              set(handles.text1,'String',texto);
                  
              texto2 = {'Matriz Jacobiana Inversa [J]^-1' };
              fnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              rnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
        
              set(handles.tabela2,'ColumnName',fnames);
              set(handles.tabela2,'RowName',rnames);
              set(handles.tabela2,'Data',inv(J));
              set(handles.text2,'String',texto2);
            case 8
              texto = {'Valores centrais de tensão e angulo - Resultado do TP'};
              
             
              dnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              cnames = {'Valores Centrais'};
              
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              
              set(handles.tabela1,'Data',Xctr);
            case 9
                   
              texto = {' Desvios das variaveis de estado (p.u.)'};
                
              dnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              
              set(handles.tabela1,'Data',delta_X);
            case 10        
              texto = {' Resultado difuso das variaveis de estados (p.u.)'};
              
              dnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',X);

            case 11  
             
               texto = {'Matriz das Admitâncias'};
           
              dnames = {'B1','B2','B3','B4','B5'};
              cnames = {'B1','B2','B3','B4','B5'};
                 
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
             
              set(handles.tabela1,'Data',Ybus);
            case 12
         
        
              texto = {'Matriz das Condutâncias'};
             G=  real (Ybus)
             B=  imag (Ybus)
              dnames = {'B1','B2','B3','B4','B5'};
              cnames = {'B1','B2','B3','B4','B5'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
            
              set(handles.tabela1,'Data',G);
           
              texto2 = {' Matriz das Susceptâncias'};
              
              dnames = {'B1','B2','B3','B4','B5'};
              cnames = {'B1','B2','B3','B4','B5'};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
              
              set(handles.tabela2,'Data',B);
            case 13
                   texto = {' Matriz das derivadas parciais da potência ativa'};
              
              D=[dP_dV d_1];
               
              cnames = {'Nó i'	'Nó k'	'dPik/dVi'	'dPik/dVk'	'dPik/Dthti'	'dPik/Dthtk'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
             
              set(handles.tabela1,'Data',D);
              
              texto2 = {' Matriz das derivadas parciais da potência Reativa'};
              D=[dP_dV d_2];
               
              cnames = {'Nó i'	'Nó k'	'dPik/dVi'	'dPik/dVk'	'dPik/Dthti'	'dPik/Dthtk'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
          
              set(handles.tabela2,'Data',D);
            case 14
                texto = {'Matriz de sensibilidades para as potências Ativas - sentido i_k'};
           
              D = [dP_dV S]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',D);          
              
              texto2 = {'Matriz de sensibilidades para as potências reativas - sentido i_k'};
             
              D = [dP_dV S2]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
              set(handles.tabela2,'Data',D);   
            case 15
              texto  = {' Desvios das potencias ativas sentido i_k (p.u.)'};
              texto2 = {' Desvios daspotencias reativas sentido i_k (p.u.)'};
               
            
             D=desvios_pot_act;
             Q=desvios_pot_react;
              cnames = {'Valores superiores','Centrais ','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
          
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            case 16
                            
              texto  = {' Resultados difusos das potencias ativas sentido i_k (p.u.)'};
              texto2 = {' Resultados difusos das potencias reativas sentido i_k (p.u.)'};
               
            
             D= delta_Pik;
             Q= delta_Qik;
              cnames = {'Valores superiores',' Centrais','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
             
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            case 17
             texto = {'Matriz de sensibilidades para as perdas Ativas - sentido i_k'};
            [Y, s1, s2]=perdasik_ki(2);
            
            
             S_PW = (S+s1)/100;
             S_Var=(S2+s2)/100;
              D = [dP_dV S_PW]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',D);          
              
              texto2 = {'Matriz de sensibilidades para as perdas reativas - sentido i_k'};
             
              D = [dP_dV S_Var]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
              set(handles.tabela2,'Data',D);   
            case 18
              texto = {' Desvios das perdas ativas sentido i_k (p.u.)'};
              texto2 = {' Desvios das perdas reativas sentido i_k (p.u.)'};
             
              %Determinação dos desvios das perdas ativas
               X =tabela_pot(:,5);  %recebe valores de pot ativa 
               X=X/100;  %converte para p.u o valor das perdas ativas obtidas do TP
               [Y, s1, s2]=perdasik_ki(2);   %chama a função perdas para retornar os valores do transito no sentido escolhido 
                Y=Y/100; %converte para p.u o valor das perdas reativas obtidas do TP
            
             S_PW = (S+s1)/100;  % soma as sensibilidades MW dos sentidos ik e ki 
             S_Var=(S2+s2)/100;  % soma as sensibilidades MVar dos sentidos ik e ki
             
             aux=S_PW; aux2= S_PW ; aux(S_PW>0)=0; aux2(S_PW<0)=0; % determina sensibilidades MW (+) & (-) 
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);   % faz sensibilidadesMW(+)*Delta_Z+sensibilidadesMW(-)*Delta_Z define coluna1
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);   % faz sensibilidadesMW(+)*Delta_Z+sensibilidadesMW(-)*Delta_Z define coluna3
             desvios_perdas_act=delta_loss; %*Retorna os desvios das perdas ativas
                
             aux=S_Var; aux2= S_Var ; aux(S_Var>0)=0; aux2(S_Var<0)=0;   % determina sensibilidades MVar (+) & (-)
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);    % faz sensibilidadesMVar(+)*Delta_Z+sensibilidadesMW(-)*Delta_Z define coluna1
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);    % faz sensibilidadesMVar(+)*Delta_Z+sensibilidadesMW(-)*Delta_Z define coluna3 
             desvios_perdas_reac=delta_loss;       %*Retorna os desvios das perdas reaativas
         
             D=[dP_dV desvios_perdas_act];
             Q=[dP_dV desvios_perdas_reac];
              cnames = {'Nó i','Nó k','Valores superiores',' ','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
          
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            case 19
             texto = {' Desvios das perdas ativas sentido i_k (p.u.)'};
             texto2 = {' Desvios das perdas reativas sentido i_k (p.u.)'};
               
              X =tabela_pot(:,5);  %recebe valores de pot ativa 
              X=X/100;  %converte para p.u o valor das perdas ativas obtidas do TP
              [Y, s1, s2]=perdasik_ki(2);   %chama a função perdas para retornar os valores do transito no sentido escolhido 
              Y=Y/100; %converte para p.u o valor das perdas reativas obtidas do TP
              S_PW = (S+s1)/100;
              S_Var=(S2+s2)/100;
             
             aux=S_PW; aux2= S_PW ; aux(S_PW>0)=0; aux2(S_PW<0)=0;
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);
             desvios_perdas_act=delta_loss;
                
             aux=S_Var; aux2= S_Var ; aux(S_Var>0)=0; aux2(S_Var<0)=0;
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);
             desvios_perdas_reac=delta_loss;
             desvios_perdas_act(:,2)=real(X);     %prenche valores centrais na matriz dos desvios MW
             desvios_perdas_reac(:,2)=imag(Y)     %prenche valores centrais na matriz dos desvios MVar

             desvios_perdas_act(:,1) =desvios_perdas_act(:,2)+desvios_perdas_act(:,1);   % faz se Perdas_ctr + Delta_PerdasMW~ coluna1
             desvios_perdas_act(:,3) =desvios_perdas_act(:,2)+desvios_perdas_act(:,3);   % *Retorna o resultado das perdas de potências MW difuso no sentido ik (p.u.)
              desvios_perdas_reac(:,1) =desvios_perdas_reac(:,2)+desvios_perdas_reac(:,1);   % faz se Perdas_ctr + Delta_PerdasMVar~ coluna1
             desvios_perdas_reac(:,3) =desvios_perdas_reac(:,2)+desvios_perdas_reac(:,3);    %*Retorna o resultado das perdas de potências MVar difuso no sentido ik (p.u.)
            
             D=[dP_dV desvios_perdas_act];
             Q=[dP_dV desvios_perdas_reac];
              cnames = {'Nó i','Nó k','Valores superiores',' ','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
          
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            
      end  
  else  
      switch posicao
            case 1
    texto2= {'TABELA I - Barramentos (pu)' 'NB: O segundo índice (a, b, c) assinala os três valores caraterísticos de cada número triangular '};
                cn=[
    0	0	0	0	0	0	17	20	22	3	5	7 
    0	0	0	0	0	0	54	60	67	20	25	30
    0	0	0	0	0	0	38	40	45	12	15	17
    143	150	155	0	0	0	25	30	31	12	15	18
    0	0	0	0	0	0	95	100	106	35	40	46];
    cn=cn/100; % *passando para pu
              cnames = {'Pga', 'Pgb', 'Pgc', 'Qga', 'Qgb', 'Qgc', 'Pca', 'Pcb', 'Pcc', 'Qca', 'Qcb', 'Qcc'};
              dnames = {'B1' 'B2' 'B3' 'B4' 'B5' };
              set(handles.tabela2,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'Data',cn);
              set(handles.text2,'String',texto2);
            case 2
     texto = {'O resultado do trânsito de potência nos permite determinar:'  'valores centrais(V e thetas nos barramentos para o cenario de rede fornecido'};
      
              cnames = {'Tensões(pu)','Ângulos(rad)','Tensões(KV)','consumoPW','consumoVar'};
              dnames = {'Barr_1', 'Barr_2', 'Barr_3', 'Barr_4', 'Barr_5'};
        
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.tabela2,'Data',V_th);
              set(handles.text2,'String',texto);
            case 3
           texto = {'Geração nos barramentos de Referencia e PV'  };
          
              cnames = {'geração MW' 'geração Var'};
              dnames = {'Ger_B11', 'Ger_B12', 'Ger_B41', 'Ger_B42'};
        
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.tabela2,'Data',tabela2 );
              set(handles.text2,'String',texto);
             
            case 4
         texto = {'Resultado do trânsito de potência no sentido  ' '- valores centrais i-k  k-i'};
              cnames = {'P_ik','Q_ik','P_ki','Q_ki','Perdas PW','perdas Var'};
              dnames = {'B1_2_1', 'B1_5_1', 'B2_3_1', 'B2_5_2','B3_4_3','B4_5_4'};
        
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.tabela2,'Data',tabela2 );
              set(handles.text2,'String',texto);
            
                set(handles.tabela2,'Data',tabela_pot);
            case 5
       texto = {'Potências injetadas, valores centrais e difusos.'};
                     
              dnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto);
              set(handles.tabela2,'Data',delta_Ds);
            case 6
                texto = {'Desvios das potências injetadas (p.u.)'};
                         
              dnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto);
              set(handles.tabela2,'Data',delta_Z);
            case 7
              texto = {'Matriz Jacobiana ' };
              dnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              cnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',J);
              set(handles.text1,'String',texto);
                  
              texto2 = {'Matriz Jacobiana Inversa [J]^-1' };
              fnames = {'P2','P3','P4',	'P5','Q2','Q3','Q5'};
              rnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
        
              set(handles.tabela2,'ColumnName',fnames);
              set(handles.tabela2,'RowName',rnames);
              set(handles.tabela2,'Data',inv(J));
              set(handles.text2,'String',texto2);
            case 8
              texto = {'Valores centrais de tensão e angulo - Resultado do TP'};
              
             
              dnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              cnames = {'Valores Centrais'};
              
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto);
              
              set(handles.tabela2,'Data',Xctr);
            case 9
             texto = {' Desvios das variaveis de estado (p.u.)'};
                
              dnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto);
              
              set(handles.tabela2,'Data',delta_X);
            case 10
             texto = {' Resultado difuso das variaveis de estados (p.u.)'};
              
              dnames = {'theta_2','theta_3','theta_4','theta_5','V2','V3','V5'};
              cnames = {'Valores superiores','Valores centrais','Valores inferiores'};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto);
              set(handles.tabela2,'Data',X);
            case 11
             texto = {'Matriz das Admitâncias'};
           
              dnames = {'B1','B2','B3','B4','B5'};
              cnames = {'B1','B2','B3','B4','B5'};
                 
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto);
             
              set(handles.tabela2,'Data',Ybus);
            case 12
       
              texto = {'Matriz das Condutâncias'};
             G=  real (Ybus)
             B=  imag (Ybus)
              dnames = {'B1','B2','B3','B4','B5'};
              cnames = {'B1','B2','B3','B4','B5'};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
            
              set(handles.tabela1,'Data',G);
           
              texto2 = {' Matriz das Susceptâncias'};
              
              dnames = {'B1','B2','B3','B4','B5'};
              cnames = {'B1','B2','B3','B4','B5'};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
              
              set(handles.tabela2,'Data',B);
            case 13
                      texto = {' Matriz das derivadas parciais da potência ativa'};
              
              D=[dP_dV d_1];
               
              cnames = {'Nó i'	'Nó k'	'dPik/dVi'	'dPik/dVk'	'dPik/Dthti'	'dPik/Dthtk'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
             
              set(handles.tabela1,'Data',D);
              
              texto2 = {' Matriz das derivadas parciais da potência Reativa'};
              D=[dP_dV d_2];
               
              cnames = {'Nó i'	'Nó k'	'dPik/dVi'	'dPik/dVk'	'dPik/Dthti'	'dPik/Dthtk'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
          
              set(handles.tabela2,'Data',D);
            case 14
             texto = {'Matriz de sensibilidades para as potências Ativas - sentido k_i'};
           
              D = [dP_dV S]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',D);          
              
              texto2 = {'Matriz de sensibilidades para as potências reativas - sentido k_i'};
             
              D = [dP_dV S2]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
              set(handles.tabela2,'Data',D);   
            case 15
              texto  = {' Desvios das potencias ativas sentido k_i (p.u.)'};
              texto2 = {' Desvios daspotencias reativas sentido k_i (p.u.)'};
               
            
             D=desvios_pot_act;
             Q=desvios_pot_react;
              cnames = {'Valores superiores','Centrais ','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
          
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            case 16
             texto  = {' Resultados difusos das potencias ativas sentido k_i (p.u.)'};
              texto2 = {' Resultados difusos das potencias reativas sentido k_i (p.u.)'};
               
            
             D= delta_Pik;
             Q= delta_Qik;
              cnames = {'Valores superiores',' Centrais','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
             
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            case 17
       
             texto = {'Matriz de sensibilidades para as perdas Ativas - sentido k_i'};
            [Y, s1, s2]=perdasik_ki(2);
            
            
             S_PW = (S+s1)/100;
             S_Var=(S2+s2)/100;
              D = [dP_dV S_PW]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.tabela1,'Data',D);          
              
              texto2 = {'Matriz de sensibilidades para as perdas reativas - sentido i_k'};
             
              D = [dP_dV S_Var]    
              cnames = {'Nó i','Nó k',' ',' ',' ',' ',' ',' '};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text2,'String',texto2);
              set(handles.tabela2,'Data',D);   
            case 18
            texto = {' Desvios das perdas ativas sentido k_i (p.u.)'};
              texto2 = {' Desvios das perdas reativas sentido k_i (p.u.)'};
               
             
             X =tabela_pot(:,5);
             X=X/100;
             [Y, s1, s2]=perdasik_ki(2);
             Y=Y/100;
            
             S_PW = (S+s1)/100;
             S_Var=(S2+s2)/100;
             
             aux=S_PW; aux2= S_PW ; aux(S_PW>0)=0; aux2(S_PW<0)=0;
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);
             desvios_perdas_act=delta_loss;
                
             aux=S_Var; aux2= S_Var ; aux(S_Var>0)=0; aux2(S_Var<0)=0;
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);
             desvios_perdas_reac=delta_loss;
         
             D=[dP_dV desvios_perdas_act];
             Q=[dP_dV desvios_perdas_reac];
              cnames = {'Nó i','Nó k','Valores superiores',' ','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
          
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
            case 19
             texto = {' Desvios das perdas ativas sentido k_i (p.u.)'};
              texto2 = {' Desvios das perdas reativas sentido k_i (p.u.)'};
               
             
             X =tabela_pot(:,5);
             X=X/100;
             [Y, s1, s2]=perdasik_ki(2);
             Y=Y/100;
            
             S_PW = (S+s1)/100;
             S_Var=(S2+s2)/100;
             
             aux=S_PW; aux2= S_PW ; aux(S_PW>0)=0; aux2(S_PW<0)=0;
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);
             desvios_perdas_act=delta_loss;
                
             aux=S_Var; aux2= S_Var ; aux(S_Var>0)=0; aux2(S_Var<0)=0;
             delta_loss(:,1)=aux2*delta_Z(:,1)+aux*delta_Z(:,3);
             delta_loss(:,3)=aux*delta_Z(:,1)+aux2*delta_Z(:,3);
             desvios_perdas_reac=delta_loss;
             desvios_perdas_act(:,2)=real(X);
             desvios_perdas_reac(:,2)=imag(Y)

             desvios_perdas_act(:,1) =desvios_perdas_act(:,2)+desvios_perdas_act(:,1);   % faz se Xctr + Delta_X~
             desvios_perdas_act(:,3) =desvios_perdas_act(:,2)+desvios_perdas_act(:,3);   % *Retorna o resultado do trânsito de potências AC difuso no sentido ik (p.u.)
              desvios_perdas_reac(:,1) =desvios_perdas_reac(:,2)+desvios_perdas_reac(:,1);   % faz se Xctr + Delta_X~
             desvios_perdas_reac(:,3) =desvios_perdas_reac(:,2)+desvios_perdas_reac(:,3);   % *Retorna o resultado do trânsito de potências AC difuso no sentido ik (p.u.)
            
             D=[dP_dV desvios_perdas_act];
             Q=[dP_dV desvios_perdas_reac];
              cnames = {'Nó i','Nó k','Valores superiores',' ','Valores inferiores'};
              dnames = {' ',' ',' ',' ',' ',' ',' '};
          
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela2,'ColumnName',cnames);
              set(handles.tabela2,'RowName',dnames);
              set(handles.text1,'String',texto);
              set(handles.text2,'String',texto2);
              set(handles.tabela1,'Data',D);
              set(handles.tabela2,'Data',Q);
        end 
 end

