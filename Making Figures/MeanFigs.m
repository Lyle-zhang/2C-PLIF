function [ A1, A2, Xs, Ys ] = MeanFigs( MeanNo , S, Shift, TitleText, FileName,A1,A2)

%Intilize Figure
    Figure1=figure(1);
    clf(Figure1);
    set(Figure1,'PaperUnits', 'inches', 'PaperSize', [8.5 11]);
    set(Figure1,'defaulttextinterpreter','latex')
    load('Vars/PreRunVars.mat','Scale')

%First Plot: Means
subplot(2,2,1)
mean2=0;  %need to intialize or gets confused with a funciton :/
load(['Vars/ProcMeansE' sprintf('%05d', MeanNo)]);
    [y x]=size(mean1);
    
    Xs=(x:-1:1)./Scale+Shift; %shift estimated from Focus 18 img.
    Ys=(y:-1:1)./Scale;
    
    X1=round(x/6);
    X2=round(x/2);
    X3=round(5*x/6);
    
        [sigma1,mu1,S1]=mygaussfit(Ys,mean(mean1,2));
        [sigma2,mu2,S2]=mygaussfit(Ys,mean(mean2,2));
    if nargin == 5
        A1=max(mean1(:));
        A2=max(mean2(:));
    end
    mean1=mean1/A1;
    mean2=mean2/A2;
    
    Ys=Ys-(mu1+mu2)/2;
    
    Img=ColorChangeWhite(mean1,mean2,2);
    imshow(Img,'XData',Xs,'YData',Ys);
    hold on;axis on;
        plot(Xs(X1)+5.*mean(mean1(:,(X1-50):(X1+50) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X1)+5.*mean(mean2(:,(X1-50):(X1+50) ),2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X2)+5.*mean(mean1(:,(X2-50):(X2+50) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X2)+5.*mean(mean2(:,(X2-50):(X2+50) ),2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X3)+5.*mean(mean1(:,(X3-50):(X3+50) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X3)+5.*mean(mean2(:,(X3-50):(X3+50) ),2),Ys,'b-.','LineWidth',1.5);
        
        plot(Xs,ones(1,length(Xs))*S/2,'k--','LineWidth',1.5);
        plot(Xs,-ones(1,length(Xs))*S/2,'k--','LineWidth',1.5);
    hold off;
    title('$\frac{\left< C_1 \right>}{\left< C_1 \right>_C}$ and $\frac{\left< C_2 \right>}{\left< C_2 \right>_C}$','Interpreter','latex','FontSize',12)

%
subplot(2,2,2)
load(['Vars/RMSEe' sprintf('%05d', MeanNo)]);
    RMSE1=RMSE1/A1;
    RMSE2=RMSE2/A2;
    Img=ColorChangeWhite(RMSE1/10,RMSE2/10);
    imshow(Img,'XData',Xs,'YData',Ys);
    hold on;axis on;
        plot(Xs(X1)+1.*mean(RMSE1(:,(X1-50):(X1+50) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X1)+1.*mean(RMSE2(:,(X1-50):(X1+50) ),2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X2)+1.*mean(RMSE1(:,(X2-50):(X2+50) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X2)+1.*mean(RMSE2(:,(X2-50):(X2+50) ),2),Ys,'b-.','LineWidth',1.5);

        plot(Xs(X3)+1.*mean(RMSE1(:,(X3-50):(X3+50) ),2),Ys,'r-.','LineWidth',1.5);
        plot(Xs(X3)+1.*mean(RMSE2(:,(X3-50):(X3+50) ),2),Ys,'b-.','LineWidth',1.5);
    hold off;
    title('$\frac{\sigma_1}{\left< C_1 \right>_C}$ and $\frac{\sigma_2}{\left< C_2 \right>_C}$','Interpreter','latex','FontSize',12)

%
subplot(2,2,3)
load(['Vars/CovE' sprintf('%05d', MeanNo)]);
    C1C2=C1C2/(A1*A2);
    Cov=Cov/(A1*A2);
    imagesc(Xs,Ys,C1C2);caxis([0 1])
    colormap(flipud(gray));
    freezeColors;
    hold on;axis image;
        plot(Xs(X1)+10.*mean(C1C2(:,(X1-50):(X1+50) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X2)+10.*mean(C1C2(:,(X2-50):(X2+50) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X3)+10.*mean(C1C2(:,(X3-50):(X3+50) ),2),Ys,'k-.','LineWidth',1.5);
    hold off;
    cbfreeze(colorbar('location','South'));
    title('$\frac{\left< C_1 C_2 \right>}{\left< C_1 \right>_C\left< C_2 \right>_C}$','Interpreter','latex','FontSize',12)
    
subplot(2,2,4);
    Rho=Cov./(RMSE1.*RMSE2);
    Rho(isinf(Rho))=0;
    Rho(isnan(Rho))=0;
    imagesc(Xs,Ys,Rho);
    B(1,:)= [0:1/31:1 ones(1,32)];
        B(2,:)= [0:1/31:1 1:-1/31:0];
        B(3,:)= [ones(1,32) 1:-1/31:0];
        colormap(B');caxis([-1 1]);colorbar('location','SouthOutside')
    hold on;axis image;
        plot(Xs(X1)+10.*mean(Rho(:,(X1-50):(X1+50) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X2)+10.*mean(Rho(:,(X2-50):(X2+50) ),2),Ys,'k-.','LineWidth',1.5);

        plot(Xs(X3)+10.*mean(Rho(:,(X3-50):(X3+50) ),2),Ys,'k-.','LineWidth',1.5);
    hold off;
    title('$\rho=\frac{\left< c_1^\prime c_2^\prime \right>}{\sigma_1 \sigma_2}$','Interpreter','latex','FontSize',12)

annotation(Figure1,'textbox',...
    [0.4 0.8 0.2 0.189873417721519],...
    'String',{TitleText},...
    'FitBoxToText','off',...
    'LineWidth',0,'EdgeColor','none',...
    'Interpreter','latex','FontSize',18,...
    'HorizontalAlignment','center');

FileName=[FileName 'Means.tif'];
print('-r500','-dtiff',FileName);
end

