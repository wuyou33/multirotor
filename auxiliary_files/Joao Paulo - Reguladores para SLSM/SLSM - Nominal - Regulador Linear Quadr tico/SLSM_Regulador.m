%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Regulador Linear Quadr�tico para SLSM                 %
%                            Dependente do Modo                           %
%                                                                         %
% Algoritmo do Artigo "Recursive Robust Regulator for Discrete-time MJLS  %
% via Penalty Game Approach" de J.P. Cerri, M.H. Terra and J.Y. Ishihara  %
% (2010).                                                                 %
%                                                                         %
% Dados de entrada -> arquivo: Dados do sistema                           %
%                     escalar: N     - horizonte                          %
%                              parms - par�metro que caracteriza o valor  %
%                                      de mi (exato/aproximado)           %
%                              mi    - par�metro de penalidade            %
%                                                                         %
% Dados de saida -> matriz P: solu��es das Equa��es de Riccati            %
%                   matriz K: ganhos de realimenta��o                     %
%                   matriz L: malhas fechadas                             %
%                                                                         %
%%=======================================================================%%
% Daiane C. Bortolin    -    daiane.bortolin@usp.br   -    Outubro / 2016 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [P,K,L] = SLSM_Regulador(N,parms,mi)

disp('*********************************************')
disp('    Regulador Linear Quadr�tico para SLSM    ')
disp('*********************************************')

%%%---------------------------------------------------

% Verifica os valores das vari�veis de entrada

  if mi <= 0
     error('Valor de mi deve ser positivo.')
 end

  if (parms ~= 0) && (parms ~= 1)
     error('parms = {0,1}.')
  end 
 
%%%---------------------------------------------------

% Vari�veis globais
  global m n s Prob F G Q R P
  
%%%---------------------------------------------------- 

% Variaveis auxiliares
  In = eye(n);
  Im = eye(m);

%%%---------------------------------------------------
  
 % Calculo da matriz Sigma
   MSigma = parms * mi^(-1) * In;
          
%%%=====================================================================%%%
%%%                         Loop do Algoritmo                           %%%
%%%=====================================================================%%%

for k = 1:N
        
    for i = 1:s
                        
        % Calculo do operador Psi
          OpPsi = zeros(n);
          for j = 1:s                
              OpPsi = OpPsi + Prob(i,j) * P(:,:,k,j);
          end
                   
        %%%---------------------------------------------------
          
        P_cal = blkdiag( OpPsi,R(:,:,i),Q(:,:,i) );
                  
        A_cal = [ eye(n)      zeros(n,m);...
                  zeros(m,n)  Im        ; ...
                  zeros(n)    zeros(n,m); ...
                  In         -G(:,:,i)  ];
          
        %%%=============================================================%%%
        %%%           CONDI��O PARA A EXIST�NCIA DA SOLU��O             %%%
        %%%=============================================================%%%
        %
        % %%% Condi��es sobre o posto   
        % %%%---------------------------------------------------
        %
        % % posto coluna pleno
        %  postoA = [ size(A_cal,2) rank(A_cal) ] 
        %  
        % % posto linha pleno
        %  EA = [ In -G(:,:,i) ];
        %  postoEA = [ size(EA,1) rank(EA) ] 
        %  
        % pause          
        %%%----------------------------------------------------
        
        Aux1 = [ In -G(:,:,i) ];
         if ( rank( Aux1 ) < size( Aux1,1 ) ) && parms ==0
            error('Problema sem solu��o para parms = 0.')           
        end
             
        %%%=============================================================%%%
        
        Aux_W = blkdiag( inv(P_cal),MSigma );
            
        W = [ Aux_W  A_cal; A_cal' zeros(n+m) ];
        
        %%% Avalia o n�mero de condi��o da matriz W  
        %%%---------------------------------------------------- 
         if rcond(W) <= eps
            error('ErrorTests:convertTest', ...
             'Matriz W � mal condicionada \n Modifique as vari�veis parms e/ou mi.')
         end   
        
        %%----------------------------------------------------
        
        Z = [ zeros(3*n+m,n) ; In ; zeros(m,n) ];
                 
        V = [ zeros(4*n+m,m) ; Im ];
                   
        U = [ zeros(n+m,n) ; -In ; F(:,:,i) ; zeros(n+m,n) ];
           
        %%%=============================================================%%%
        %%%            [L; K; P] = [Z V U ]^T * inv(W) * U              %%%
        %%%=============================================================%%%
            
        Sol = [ Z V U ]' * inv(W) * U;
          
        Aux2 = mat2cell( Sol,[n m n],[n] );
        
        L(:,:,k,i) = Aux2{1};
        
        K(:,:,k,i) = Aux2{2};
                      
        P(:,:,k+1,i) = Aux2{3};
        %%%---------------------------------------------------
        
        % Verifica se a Riccati n�o � definida positiva 
           if min( eig( P(:,:,k+1,i ) ) ) <= 0
              error('A Riccati n�o � definida positiva.') 
           end
          
        %%%---------------------------------------------------

    end % for i

end % for k

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%