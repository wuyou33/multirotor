%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Dados do Sistema                              %
%             Sistema Nominal com Matriz de Transi��o Nominal             %
%                                                                         %
% Exemplo da Tese "Controle e Filtragem para Sistemas Lineares Discretos  %
% Incertos sujeitos a Saltos Markovianos" de J.P. Cerri (2013, Ex 2.3,    %
% pg 49).                                                                 %
%                                                                         %
% x(k+1) = F(:,:,i) * x(k) + G(:,:,i) * u(k)                              %
% Prob (Matriz de transi��o)                                              %
% Q, R (Matrizes de pondera��o)                                           %
% P  (Solucao da Equa��o de Riccati)                                      %
%                                                                         %
%%=======================================================================%%
% Daiane C. Bortolin                                       Outubro / 2016 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Prob = [ 0.67 0.17 0.16 ; 0.30 0.47 0.23 ; 0.26 0.10 0.64]; 
                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%                        Dados do Sistema                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0  = [ 1 ; 0.5 ];
 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %

F(:,:,1) = [ 2 1 ; -2.5 3.2 ];

F(:,:,2) = [ 2 1 ; -4.3 4.5 ];

F(:,:,3) = [ 1 1 ;  5.3 5.2 ];

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %

G(:,:,1) = [ 0 ; 1 ];

G(:,:,2) = G(:,:,1);

G(:,:,3) = G(:,:,1);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %

Q(:,:,1) = [ 3.60 -3.80 ; -3.80 4.87 ];

Q(:,:,2) = [ 3.38 -2.54 ; -2.54 2.70 ];

Q(:,:,3) = [ 5    -4.50 ; -4.50 4.5 ];

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %

R(:,:,1) = 2.6;

R(:,:,2) = 1.165;

R(:,:,3) = 1.111;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %

% Dimensoes do problema

  s = size( Prob,1 );
  n = size( F(:,:,1),1 );
  m = size( G(:,:,1),2 );

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
 
% Riccati inicial
  for i = 1:s
      P(:,:,1,i) = eye(n);  
  end 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%