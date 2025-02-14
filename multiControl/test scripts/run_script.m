% Octorotor simulation
% refer to "doc multicontrol" or "doc multicopter" for more information

addpath('../../multiControl/')
addpath('../../multiControl/utils')
warning('off','all')
clear all
clc
%% Configuration for +8 coaxial octorotor
% Creates simulation class
multirotor = multicontrol(8);
% multirotor.supressVerbose()
% Define rotor positions
positions = [[0.34374 0.34245 0.0143]',[-0.341 0.34213 0.0143]',[-0.34068 -0.34262 0.0143]',[0.34407 -0.34229 0.0143]',[0.33898 0.33769 0.0913]',[-0.33624 0.33736 0.0913]',[-0.33591 -0.33785 0.0913]',[0.3393 -0.33753 0.0913]'];
% positions = [0.4852*cos(pi*(0:45:359)/180)
%              0.4852*sin(pi*(0:45:359)/180)
%              ones(1,8)*0.0143];             
multirotor.setRotorPosition(1:8,positions);
% Define rotor orientations
orientations = [[-0.061628417 -0.061628417 0.996194698]',[0.061628417 -0.061628417 0.996194698]',[0.061628417 0.061628417 0.996194698]',[-0.061628417 0.061628417 0.996194698]',[-0.061628417 -0.061628417 0.996194698]',[0.061628417 -0.061628417 0.996194698]',[0.061628417 0.061628417 0.996194698]',[-0.061628417 0.061628417 0.996194698]'];
%orientations = [[0 0 1]',[0 0 1]',[0 0 1]',[0 0 1]',[0 0 1]',[0 0 1]',[0 0 1]',[0 0 1]'];
multirotor.setRotorOrientation(1:8,orientations);
% Define aircraft's inertia
multirotor.setMass(6.015);
mass = 2;
inertia =   [0.3143978800	0.0000861200	-0.0014397600
            0.0000861200	0.3122127800	0.0002368800
            -0.0014397600	0.0002368800	0.5557912400];
multirotor.setInertia(inertia);
payloadRadius = 0.3*mean(sqrt(sum(positions.^2)));
multirotor.setPayload([0, 0, -payloadRadius],mass,eye(3)*2*mass*payloadRadius*payloadRadius/5);
% multirotor.setPayload([0, 0, 0],mass,eye(3)*2*mass*payloadRadius*payloadRadius/5);
% Define aircraft's drag coeff
friction = [0.25	0	0
            0	0.25	0
            0	0	0.25];
multirotor.setFriction(friction);
multirotor.setAngularFilterGain([0,0,0.9]);
% Define lift and drag coefficients
speed = [0
        200
        416.5751859
        435.2676622
        462.5052705
        472.6526147
        491.345091
        501.4924353
        520.1849116
        530.3322559
        549.0247321
        567.7172084
        586.4096847
        748.2865294
        1466];
liftCoeff = [0.00004
            0.00007
            0.00009663400821486720
            0.00010197039400480800
            0.00010177480503994200
            0.00010886498777293000
            0.00011048831185009000
            0.00011230119869840700
            0.00010908666646728400
            0.00011227432775784800
            0.00010996476733082600
            0.00010862374599149600
            0.00010409054272222600
            0.00006567742093581670
            0];
 dragCoeff = [0.0000005
            0.00000075
            0.00000115158401406177
            0.00000131849846466781
            0.00000140132963964922
            0.00000156543968817590
            0.00000165553807692624
            0.00000178787094426600
            0.00000184631980295481
            0.00000195397512083756
            0.00000198893164777812
            0.00000201512348657737
            0.00000203398711313428
            0.00000136514255905061
            0.0000005];
% multirotor.setRotorLiftCoeff(1:8,[speed liftCoeff],'smoothingspline',1);
% multirotor.setRotorDragCoeff(1:8,[speed dragCoeff],'smoothingspline',1);
multirotor.setRotorLiftCoeff(1:8,ones(1,8)*6.97e-5);
multirotor.setRotorDragCoeff(1:8,ones(1,8)*1.033e-6);
% Define rotor inertia
multirotor.setRotorInertia(1:8,0.00047935*ones(1,8));
% Sets rotors rotation direction for control allocation
rotationDirection = [1 -1 1 -1 -1 1 -1 1]';
% rotationDirection = [1 1 1 1 -1 -1 -1 -1]';
multirotor.setRotorDirection(1:8,rotationDirection);
multirotor.setRotorMaxSpeed(1:8,729*ones(1,8));
multirotor.setRotorMinSpeed(1:8,0*ones(1,8));
multirotor.setInitialRotorSpeeds(328*rotationDirection);
multirotor.setInitialRotorCurrents(1*rotationDirection);
multirotor.setInitialInput(0*rotationDirection);
multirotor.setInitialVelocity([0;0;0]);
multirotor.setInitialPosition([0;0;0]);
multirotor.setInitialAngularVelocity([0;0;0]);
multirotor.setRotorRm(1:8,0.0975*ones(1,8));
multirotor.setRotorL(1:8,0.0033*ones(1,8));
multirotor.setRotorKt(1:8,0.02498*ones(1,8));
multirotor.setRotorKv(1:8,340*ones(1,8));
multirotor.setRotorMaxVoltage(1:8,22*ones(1,8));
multirotor.setRotorOperatingPoint(1:8,352*[1 1 1 1 1 1 1 1]);

%% Previous case
% % Creates simulation class
% multirotor = multicontrol(8);
% multirotor.supressVerbose()
% % Define rotor positions (from rotor 1 to 8 in this order. using default rotor orientations)
% positions = [[0.25864 0 0.10]',[0 -0.25864 0.10]',[-0.25864 0 0.10]',[0 0.25864 0.10]',[0.25864 0 -0.10]',[0 -0.25864 -0.10]',[-0.25864 0 -0.10]',[0 0.25864 -0.10]'];
% multirotor.setRotorPosition([1 2 3 4 5 6 7 8],positions);
% % Define aircraft's inertia
% inertia = 1.5*[0.031671826 0 0;0 0.061646669 0;0 0 0.032310702];
% multirotor.setMass(1.85);
% multirotor.setInertia(inertia);
% % Define lift coefficients (using default drag coefficients)
% multirotor.setRotorLiftCoeff([1 2 3 4 5 6 7 8],0.00000289*[1 1 1 1 1 1 1 1]);
% % Sets rotors rotation direction for control allocation
% rotationDirection = [1 -1 1 -1 -1 1 -1 1]';
% multirotor.setRotorDirection([1 2 3 4 5 6 7 8],rotationDirection);
% multirotor.setRotorMaxSpeed(1:8,1200*[1 1 1 1 1 1 1 1])
% multirotor.setRotorOperatingPoint(1:8,340*[1 1 1 1 1 1 1 1]);

%% Controller configuration
% Trajectory controller
% PID:
kp = [95.75 100.250020593405 150.0000495910645];
ki = [14.0625572204590 15 19];
kd = [49.5000000000000 49.2500000000000 60];
kdd = [11.5001522749662 7.25000000000000 13.2500582933426];
% RLQ-R Passive:
% kp = [30 70 100];ki = [10 20 40];kd = [20 50 70];kdd = [3 5 2];
% RLQ-R Passive Modified:
% kp = [135.996733981483 153.135876078688 60];
% ki = [2 2 67.6223960552471]
% kd = [25 42.6592793583164 30];
% kdd = [3 3 3];
% RLQ-R Passive Modified with PIDD:
% kp = [70 70 100];ki = [5 5 40];kd = [40 40 30];kdd = [2 2 1];
% SOSMC Passive and with PIDD:
% kp = [300 300 100];ki = [10 10 40];kd = [70 70 70];kdd = [35 35 2];
% SOSMC Passive Direct:
% kp = [100 100 100];ki = [10 10 40];kd = [80 90 70];kdd = [35 35 1];
% Adaptive:
%kp = [70 70 100];ki = [10 10 40];kd = [40 40 70];kdd = [15 15 2];
% Adaptive with PIDD:
% kp = [70 70 100];ki = [10 10 40];kd = [40 40 70];kdd = [15 15 2];
% Adaptive Direct:
% kp = [60 60 100];ki = [20 10 40];kd = [40 40 70];kdd = [15 15 2];
% Markovian passive:
% kp = [50 50 50];ki = [10 10 10];kd = [20 20 20];kdd = [3 3 3];
% kp = [0 0 0];ki = [0 0 0];kd = [0 0 0];kdd = [0 0 0];
% kp = [389.67 404.17 108.46]; ki =[52.17 11.03 61.61]; kd = [35.83 40 70]; kdd = [8.58 9.65 1.04];
% Markovian active:
% kp = [40 50 60];ki = [10 12 10];kd = [15 15 15];kdd = [1.5 1.8 0];
multirotor.configController('Position PIDD',kp,ki,kd,kdd);

% PID attitude controller
kp = [133.015695810318 139.750023871660 100.0000053495169];
ki = [205.937575563788 206 202];
kd = [23.0000121444464 19.2501215338707 7];
% kp = [1000 1000 1000];
% ki = [0 0 0];
% kd = [0 0 0];
multirotor.configController('PID',kp,ki,kd);

% R-LQR attitude controller
Q = diag([1e4, 1e4, 1e3,1e-1,1e-1,1e-1]);
P = Q;
R = 70*diag([1,1,.1]);
Ef = 0.1*[2 2 1 0 0 0];
Eg = 0.02*[1 1 1];
H = [1 1 1 1 1 1]';
mu = 1e30;
alpha = 1.5;
multirotor.configController('RLQ-R Passive',P,Q,R,Ef,Eg,H,mu,alpha);
multirotor.configController('RLQ-R Active',P,Q,R,Ef,Eg,H,mu,alpha);
Q = diag([136440926.976679 165320359.177077 338043223.930318 811714985.079850 470697017.566526 5000000]);
P = diag([5000000 5000000 5000000 51735772.1962334 13237193.7735967 5000000]);
R = diag([582.052408422866 1.00000000000000e-05 1.00000000000000e-05 1.00000000000000e-05 169.710172090567 1.00000000000000e-05 1.00000000000000e-05 42.7977897114965]);
Ef = [64242.0816790375 35819.4947577920 10 56082.0041098398 0 0];
Eg = [15572.0046803445 36270.6230228744 1000 1000 1000 1000 1000 1000];
H = [1 1 1 1 1 1]';
mu = 1.00000000000000e+20;
alpha = 1.5;
multirotor.setAngularFilterGain([0.893982849632920 0.866909075664830 0.713328100616703]);
multirotor.configController('RLQ-R Passive Modified',P,Q,R,Ef,Eg,H,mu,alpha);
multirotor.configController('RLQ-R Active Modified',P,Q,R,Ef,Eg,H,mu,alpha);
% P = eye(9);
Q = 500000*blkdiag(1e1, 1e1, 1e1, 1e1, 1e1, 1e1,1e1,1e1,1e1);
P = Q;
R = 0.00001*eye(8);
H = [1 1 1 1 1 1 1 1 1]';
Ef = 10*[1 1 1 1 1 1 0 0 0];
Eg = 40*[1 1 1 1 1 1 1 1];
mu = 1e22;
alpha = 1.5;
multirotor.configController('RLQ-R Passive Modified with PIDD',P,Q,R,Ef,Eg,H,mu,alpha);
multirotor.configController('RLQ-R Active Modified with PIDD',P,Q,R,Ef,Eg,H,mu,alpha);

% SOSMC controller
c = 3*diag([1,1,1]);
alpha =  2*diag([1,1,1]);
lambda = .1*diag([1,1,1]);
multirotor.configController('SOSMC Passive',c,lambda,alpha);
multirotor.configController('SOSMC Active',c,lambda,alpha);
c = 3*diag([1,1,1,2,2,2]);
alpha = 2*diag([1,1,1,2,2,2]);
lambda = .1*diag([1,1,1,2,2,2]);
multirotor.configController('SOSMC Passive with PIDD',c,lambda,alpha);
multirotor.configController('SOSMC Active with PIDD',c,lambda,alpha);
c =1.5*diag([1,1,4,2,2,2]);
alpha = 5500*...
           [ 1 -1  0.1 -0.001 -0.01 1
             1  1 -0.1  0.001 -0.01 1
            -1  1  0.1  0.001  0.01 1
            -1 -1 -0.1 -0.001  0.01 1
             1 -1 -0.1 -0.001 -0.01 1
             1  1  0.1  0.001 -0.01 1
            -1  1 -0.1  0.001  0.01 1
            -1 -1  0.1 -0.001  0.01 1];
lambda = 1000*...
            [1 -1  0.1 -0.001 -0.001 1
             1  1 -0.1  0.001 -0.001 1
            -1  1  0.1  0.001  0.001 1
            -1 -1 -0.1 -0.001  0.001 1
             1 -1 -0.1 -0.001 -0.001 1
             1  1  0.1  0.001 -0.001 1
            -1  1 -0.1  0.001  0.001 1
            -1 -1  0.1 -0.001  0.001 1];
multirotor.configController('SOSMC Passive Direct',c,lambda,alpha,1,0);
multirotor.configController('SOSMC Active Direct',c,lambda,alpha,1,0);

% Adaptive controller
Am = -2*diag([1,1,1e-2]);
Q = 1*diag([.5,.5,.0005]);
gamma1 = diag([1,1,2])*.8;
gamma2 = diag([1,1,2])*.2;
gamma3 = diag([1,1,.1])*10;
gamma4 = diag([1,1,1])*0;
multirotor.configController('Adaptive',Am,Q,gamma1,gamma2,gamma3,gamma4);
Am = -diag([.1,.1,2,2,2,0.01]);
Q = diag([1,1,1,.5,.5,.0005]);
gamma1 = diag([1,1,1,1,1,1])*.0001;
gamma2 = diag([1,1,1,1,1,1])*.0001;
gamma3 = diag([1,1,1,1,1,1])*.001;
gamma4 = diag([1,1,1,1,1,1])*.00001;
multirotor.configController('Adaptive with PIDD',Am,Q,gamma1,gamma2,gamma3,gamma4);
Am = -diag([.1,.1,2,0.001,0.001,0.001]);
Q = diag([1,1,1,0.005,0.005,.0005]);
gamma1 = eye(8)*700;
gamma2 = eye(8)*700;
gamma3 = eye(8)*2000;
gamma4 = eye(8)*0.5;
B0 = 5e3*[ -0.00001 -0.00001 4  1.5 -1.5  -3 
             0.00001 -0.00001 4  1.5  1.5 3  
             0.00001  0.00001 4 -1.5  1.5  -3  
            -0.00001  0.00001 4 -1.5 -1.5 3 
            -0.00001 -0.00001 4  1.5 -1.5 3 
             0.00001 -0.00001 4  1.5  1.5  -3  
             0.00001  0.00001 4 -1.5  1.5 3  
            -0.00001  0.00001 4 -1.5 -1.5  -3];
multirotor.configController('Adaptive Direct',Am,Q,gamma1,gamma2,gamma3,gamma4,B0);

% Markovian Passive Modified
P = 1*eye(6);
modes = [1 1 1 1 1 1 1 1
         0 1 1 1 1 1 1 1
         0 0 1 1 1 1 1 1
         0 0 0 1 1 1 1 1
         0 0 0 0 1 1 1 1];
numberOfModes = size(modes,1);

Ef = [];
Ef(:,:,1) = 10*ones(1,6);
Ef(:,:,2) = 10*ones(1,6);
Ef(:,:,3) = 10*ones(1,6);
Ef(:,:,4) = 10*ones(1,6);
Ef(:,:,5) = 10*ones(1,6);

Eg = [];
Eg(:,:,1) = 10*[1000 1000 1000 1000 1000 1000 1000 1000];
Eg(:,:,2) = 10*[1000 1000 1000 1000 1000 1000 1000 1000];
Eg(:,:,3) = 10*[1000 1000 1000 1000 1000 1000 1000 1000];
Eg(:,:,4) = 10*[1000 1000 1000 1000 1000 1000 1000 1000];
Eg(:,:,5) = 10*[1000 1000 1000 1000 1000 1000 1000 1000];

k = 1;

Eq = [];
Eq(:,:,1) = 0.000001*diag([1 1 1 1 1 1]);
Eq(:,:,2) = 0.000001*diag([1 1 1 1 1 1]);
Eq(:,:,3) = 0.000001*diag([1 1 1 1 1 1]);
Eq(:,:,4) = 0.000001*diag([1 1 1 1 1 1]);
Eq(:,:,5) = 0.000001*diag([1 1 1 1 1 1]);

Er = [];
Er(:,:,1) = diag(0.00001*modes(1,:)+~modes(1,:));
Er(:,:,2) = diag(0.00001*modes(2,:)+~modes(2,:));
Er(:,:,3) = diag(0.00001*modes(3,:)+~modes(3,:));
Er(:,:,4) = diag(0.00001*modes(4,:)+~modes(4,:));
Er(:,:,5) = diag(0.00001*modes(5,:)+~modes(5,:));

lambda = 1;
pij = 0.5*eye(numberOfModes);
eij = 2*ones(numberOfModes, numberOfModes);
multirotor.configController('Markovian RLQ-R Passive Modified',modes,P,Ef,Eg,k,Er,Eq,lambda,pij,eij);
multirotor.setAngularFilterGain([0 0 0.9]);

modes = [1 1 1 1 1 1 1 1
         0 1 1 1 1 1 1 1
         0 0 1 1 1 1 1 1
         0 0 0 1 1 1 1 1
         0 0 0 0 1 1 1 1];
numberOfModes = size(modes,1);
P = [];
for it = 1:numberOfModes
      P(:,:,it) = eye(6);  
end
Q = [];
Q(:,:,1) = 1*blkdiag(1,1,1,1,1,1);
Q(:,:,2) = 1*blkdiag(1,1,1,1,1,1);
Q(:,:,3) = 1*blkdiag(1,1,1,1,1,1);
Q(:,:,4) = 1*blkdiag(1,1,1,1,1,1);
Q(:,:,5) = 1*blkdiag(1,1,1,1,1,1);

R = [];
R(:,:,1) = 1*diag(modes(1,:)+~modes(1,:));
R(:,:,2) = 1*diag(modes(2,:)+~modes(2,:));
R(:,:,3) = 1*diag(modes(3,:)+~modes(3,:));
R(:,:,4) = 1*diag(modes(4,:)+~modes(4,:));
R(:,:,5) = 1*diag(modes(5,:)+~modes(5,:));

Ef = [];
Ef(:,:,1) = 10000*ones(1,6);
Ef(:,:,2) = 10000*ones(1,6);
Ef(:,:,3) = 10000*ones(1,6);
Ef(:,:,4) = 10000*ones(1,6);
Ef(:,:,5) = 10000*ones(1,6);

Eg = [];
Eg(:,:,1) = 1000*ones(1,8);
Eg(:,:,2) = 1000*ones(1,8);
Eg(:,:,3) = 1000*ones(1,8);
Eg(:,:,4) = 1000*ones(1,8);
Eg(:,:,5) = 1000*ones(1,8);

H = [];
H(:,:,1) = [1 1 1 1 1 1]';
H(:,:,2) = [1 1 1 1 1 1]';
H(:,:,3) = [1 1 1 1 1 1]';
H(:,:,4) = [1 1 1 1 1 1]';
H(:,:,5) = [1 1 1 1 1 1]';

pij = 0.5*eye(numberOfModes);
ei = 2*ones(1,numberOfModes);
k = 1;
mu = 1e10;
alpha = 5;

multirotor.configController('Markovian RLQ-R Active Modified',modes,P,Q,R,Ef,Eg,H,pij,ei,k,mu,alpha);
multirotor.setAngularFilterGain([0 0 0.9]);


% Adaptive control allocation
multirotor.configControlAllocator('Adaptive',-1e14*eye(6),1,0);
multirotor.configControlAllocator('Passive NMAC',1,0);
multirotor.configControlAllocator('Active NMAC',1,0);

% Configure simulator
% multirotor.setRotorStatus(1,'stuck',0.5)
multirotor.setTimeStep(0.001);
multirotor.setControlTimeStep(0.05);
multirotor.setController('PID');
multirotor.setControlAllocator('Passive NMAC');
multirotor.setAttitudeReferenceCA('Passive NMAC');
multirotor.configFDD(1,0.25)

% multirotor.setTrajectory('waypoints',[[1 1 1 0 0.4 0.4 0]',[1 2 3 0 0 0 0]',[1 2 3 0 0 0 pi/2]'],[5 10 15]);
% multirotor.setTrajectory('waypoints',[50 50 50 170*pi/180]',10);
% xpos = linspace(0,1,1000);
% ypos = linspace(0,1,1000);
% zpos = linspace(0,1,1000);
% yawpos = linspace(0,pi/2,1000);
% time = linspace(0.1,10,1000);% 
% xvel = diff(xpos)./diff(time);
% xvel(end+1) = 0;
% yvel = diff(ypos)./diff(time);
% yvel(end+1) = 0;
% zvel = diff(zpos)./diff(time);
% zvel(end+1) = 0;
% yawvel = diff(yawpos)./diff(time);
% yawvel(end+1) = 0;
% multirotor.setTrajectory('waypoints',[xpos; ypos; zpos; xvel; yvel; zvel; yawpos; yawvel],time);
% multirotor.setTrajectory('gerono',7,4,4,30,'fixed',0);
% % 
endTime = 15;
% [waypoints, time] = geronoToWaypoints(7, 4, 4, endTime, endTime/8, 'goto',0);
[waypoints, time] = geronoToWaypoints(7, 4, 4, endTime, endTime/8, 'goto', 2*pi);
multirotor.setTrajectory('waypoints',waypoints,time);

% multirotor.addCommand({'setRotorStatus(1,''stuck'',0.05)'},7)
% multirotor.addCommand({'setRotorStatus(1,''prop loss'',0.1)'},endTime/2)   
% multirotor.addCommand({'setRotorStatus(2,''prop loss'',0.1)'},endTime/2+endTime/10)   
% multirotor.addCommand({'setRotorStatus(3,''prop loss'',0.1)'},endTime/2+2*endTime/10)
% multirotor.addCommand({'setRotorStatus(4,''prop loss'',0.1)'},endTime/2+3*endTime/10)
multirotor.addCommand({'setRotorStatus(1,''motor loss'',0.001)'},endTime/2)   
multirotor.addCommand({'setRotorStatus(2,''motor loss'',0.001)'},endTime/2+endTime/10)   
multirotor.addCommand({'setRotorStatus(3,''motor loss'',0.001)'},endTime/2+2*endTime/10)
multirotor.addCommand({'setRotorStatus(4,''motor loss'',0.001)'},endTime/2+3*endTime/10)
% multirotor.addCommand({'setRotorStatus(1,''prop loss'',0.5)'},0)
% multirotor.addCommand({'setRotorStatus(6,''motor loss'',0.75)'},endTime/2)
% multirotor.addCommand({'setRotorStatus(7,''motor loss'',0.75)'},endTime/2)
multirotor.setSimEffects('motor inductance on','solver ode45')
multirotor.setLinearDisturbance('@(t) [0;1;0]*0*exp(-(t-3.75)^2/(0.5))')
multirotor.setControlDelay(0.2);
%% Run simulator
tic
multirotor.run('visualizeGraph',false,'visualizeProgress',true,'metricPrecision',0.15,'angularPrecision',5,'endError',5);
toc

multirotor.plotSim();
% multirotor.plotAxes('rotorspeed',figure())
