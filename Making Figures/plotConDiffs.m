
function plotConDiffs(USstart, USstop, DSstart,DSstop, eps, Exp, TitleTxt)
load(['Vars/Eps' sprintf('%.3f', eps) '/PDF2d'   sprintf('%05d', USstart) '-' sprintf('%05d', DSstop)], 'JPDFs');   %Proc Mean
load(['Vars/Eps' sprintf('%.3f', eps) '/ConDiff' sprintf('%05d', USstart) '-' sprintf('%05d', DSstop)], 'ConDiffs');  
  
if ~strcmp(TitleTxt,'Re1500close')
    JPDFs=JPDFs(2:4,:);
    ConDiffs=ConDiffs(2:4,:);
end

PDFsize=length(ConDiffs(1,1).jpdf);
colormap(flipud(hot));%colormap(flipud(gray.^.75));
[Ys,Xs]=size(JPDFs); 
MG=0.053;
PD=0.012;
Width=13.49414;

% if ~strcmp('Re1500far',TitleTxt)
%     Ys=Ys-2;
% end

%Width=8.5;
GraphSize=Width.*(1-MG*2.5-(Xs-1)*PD)/Xs;
Height=GraphSize*ceil(Ys/2)/(1-3*MG-(ceil(Ys/2)-1)*PD);
%Width=(Xs*GraphSize)/(1-(2+Xs)*MG);
set(0,'DefaultTextFontSize', 10)
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultAxesFontSize', 8)
set(0,'DefaultAxesFontName','Times New Roman')

Figure2=figure(2);clf;
    set(Figure2,'defaulttextinterpreter','latex',...
                'PaperUnits','centimeters','PaperSize',[Width Height],...
                'PaperPosition',[0,0,Width,Height],'Units','centimeters',...
                'Position',[1,6,Width,Height]);     

   % set(gcf,'Position', get(0,'Screensize'),... %Maximize Figure
   %         'PaperOrientation','landscape',...
   %         'PaperUnits','normalized',...
   %         'PaperType','tabloid',...
   %         'PaperPosition', [0 0 1 1]);

%Boxb(2)=floor(Box(2)/2);
%Boxb(1)=floor(Box(1)/2);
 

% Contours=[.001 .002 .005 .01 .02]; 
% for P=1:length(Contours)
%     ContLabel{P}=num2str(Contours(P),'%.4f');
% end

%cbot=3*log(Contours(1))/2-log(Contours(2))/2;
%        ctop=log(Contours(length(Contours)));
        
%Exp=.75;        
Xax=linspace(0,1,PDFsize).^Exp;
Yax=linspace(0,1,PDFsize).^Exp;
AxMax=0.6;
    for X=1:Xs
        for Y=1:ceil(Ys/2);
            
            if Y==1
                %JPDF=(JPDFs(Y,X).JPDF+JPDFs(Ys,X).JPDF')/2;
                JPDF=(ConDiffs(Y,X).jpdf'+ConDiffs(Ys,X).jpdf)/2;
                ConD1=(ConDiffs(Y,X).CD2'+ConDiffs(Ys,X).CD1)/2;
                ConD2=(ConDiffs(Y,X).CD1'+ConDiffs(Ys,X).CD2)/2;
                
                Mean1=(JPDFs(Y,X).Mean1+JPDFs(Ys,X).Mean2)/2;
                Mean2=(JPDFs(Y,X).Mean2+JPDFs(Ys,X).Mean1)/2;
                Rho=(JPDFs(Y,X).Cov/(JPDFs(Y,X).RMSE1*JPDFs(Y,X).RMSE2)+...
                     JPDFs(Ys,X).Cov/(JPDFs(Ys,X).RMSE1*JPDFs(Ys,X).RMSE2))/2;
              Alpha=(JPDFs(Y,X).Cov/(JPDFs(Y,X).Mean1*JPDFs(Y,X).Mean2)+...
                     JPDFs(Ys,X).Cov/(JPDFs(Ys,X).Mean1*JPDFs(Ys,X).Mean2))/2; 
            elseif (Y==2 && Ys-1~=Y)
                %JPDF=(JPDFs(Y,X).JPDF+JPDFs(Ys-1,X).JPDF')/2;
                JPDF=(ConDiffs(Y,X).jpdf'+ConDiffs(Ys-1,X).jpdf)/2;
                ConD1=(ConDiffs(Y,X).CD2'+ConDiffs(Ys-1,X).CD1)/2;
                ConD2=(ConDiffs(Y,X).CD1'+ConDiffs(Ys-1,X).CD2)/2;
                
                Mean1=(JPDFs(Y,X).Mean1+JPDFs(Ys-1,X).Mean2)/2;
                Mean2=(JPDFs(Y,X).Mean2+JPDFs(Ys-1,X).Mean1)/2;
                Rho=(JPDFs(Y,X).Cov/(JPDFs(Y,X).RMSE1*JPDFs(Y,X).RMSE2)+...
                     JPDFs(Ys-1,X).Cov/(JPDFs(Ys-1,X).RMSE1*JPDFs(Ys-1,X).RMSE2))/2;
              Alpha=(JPDFs(Y,X).Cov/(JPDFs(Y,X).Mean1*JPDFs(Y,X).Mean2)+...
                     JPDFs(Ys-1,X).Cov/(JPDFs(Ys-1,X).Mean1*JPDFs(Ys-1,X).Mean2))/2; 
            else
                %JPDF=(JPDFs(Y,X).JPDF);
                JPDF=ConDiffs(Y,X).jpdf';
                ConD1=ConDiffs(Y,X).CD2';
                ConD2=ConDiffs(Y,X).CD1';
                
                Mean1=JPDFs(Y,X).Mean1;
                Mean2=JPDFs(Y,X).Mean2;
                Rho=(JPDFs(Y,X).Cov/(JPDFs(Y,X).RMSE1*JPDFs(Y,X).RMSE2));
                Alpha=(JPDFs(Y,X).Cov/(JPDFs(Y,X).Mean1*JPDFs(Y,X).Mean2));
            end
            
            ConD1(isnan(ConD1))=0;
            ConD2(isnan(ConD2))=0;
%             %Want Contours at 99, 95, 90 85 80 70%
%             Precents=[.80 .60 .40 .20];
% 
%             %Make CDF(ish)thing
%             ThreshPDF=JPDF; 
%             CDF=[];
%             ProbFunc=0:.0001:.9999;
%             for Cnt=1:length(ProbFunc)
%                 ThreshPDF(ThreshPDF<ProbFunc(Cnt))=0;CDF(Cnt)=sum(ThreshPDF(:));
%             end
%             %plot(ProbFunc,CDF,'*')
%             
%             Contours=[];
%             ContLabel={};
%             for P=1:length(Precents)
%                 Index=find(CDF<Precents(P), 1, 'first');
%                 Contours(P)=ProbFunc(Index);
%                 ContLabel{P}=num2str(ProbFunc(Index),'%.4f');
%             end
%              %cbot=log(Contours(1));
%              cbot=3*log(Contours(1))/2-log(Contours(2))/2;
%              ctop=log(Contours(length(Contours)));
            
            %This gets rid of that outer annoying line.
%            JPDF(JPDF<Contours(1))=0;
            
            %Plot
            subaxis(ceil(Ys/2),Xs,X,Y,'Spacing', 0, 'Padding', PD, 'PaddingLeft',2*PD,'PaddingRight',0,'Margin', MG,'MarginLeft',2*MG,'MarginRight', MG/2,'MarginBottom', 2*MG);
                unfreezeColors;
                    MaxC=max(max(sqrt(ConD2.^2+ConD1.^2)));
                    imagesc(Xax,Yax,sqrt(ConD2.^2+ConD1.^2) );axis image;
                    %contourf(linspace(0,1,120),linspace(0,1,120),sqrt(ConD2.^2+ConD1.^2),linspace(0,MaxC,8))
                    colormap(flipud(hot.^2));caxis([0 3])
                    set(gca,'YDir','normal');hold on;
                freezeColors;
                    %plot(Mean2,Mean1,'k+');
                [sx,sy]=meshgrid(linspace(0,1,20),linspace(0,1,20));
                %streamline(linspace(0,1,120),linspace(0,1,120),ConD1,ConD2,sx,sy)
                h=streamslice(Xax,Yax,ConD1,ConD2,2,'noarrows','cubic');
                set(h,'color','k');
                %plot([Mean2 Mean2].^Exp,[0 1],'b');
                %plot([0 1],[Mean1 Mean1].^Exp,'b');
%                 subaxis(3*6,Xs*6,X*6-4,Y*6-5,5,5,'Spacing', 0, 'Padding', 0,'PaddingRight',MG,'PaddingTop',MG, 'Margin', 2*MG,'MarginRight',MG);
 
            %contourf(Xax,Yax, log(JPDF),log(Contours));hold on;
%                    plot([Mean2 Mean2].^Exp,[0 1],'b');
%                    plot([0 1],[Mean1 Mean1].^Exp,'b');
                    hold off;
                    
                    axis([0 AxMax 0 AxMax]);axis square;
                    
            %Code for Colorbar
                    %hc=colorbar('FontSize',10,'Location','East','YTick',log(Contours),'YTickLabel',ContLabel);
                    %cPos=get(hc,'Position');
                    %set(hc,'Position',[cPos(1)+cPos(3)/2,cPos(2),cPos(3)/2,cPos(4)])
                    
            %Code for text with \rho,S
                %text(.6*AxMax,.91*AxMax,{['$\rho=' sprintf('%.1f', Rho) '$']},'FontSize',8);%,...
                %['$\alpha=' sprintf('%.1f', Rho) '$']}) 
            
            if Y==1;
                title(['$x=$' num2str(JPDFs(Y,X).Xnorm)],'FontSize',11);
            end
            
            Max1=ceil(max(sum(JPDF))*10)/10;
            Max2=ceil(max(sum(JPDF'))*10)/10;
            MAX=max(Max1,Max2);
           % subaxis(3*6,Xs*6,X*6-4,Y*6,5,1,'Spacing', 0,'Padding', MG,'PaddingTop',0,'PaddingLeft',0);
           %     plot(Xax,sum(JPDF),'k');hold on;
           %     plot([Mean2 Mean2].^Exp,[0 1],'b');hold off;
           %     axis([0 1 0 Max1]);

                if Y==ceil(Ys/2);
                    xlabel('$\Phi_B$');
                    set(gca,'XTick',linspace(0,1,6).^Exp,...
                        'XTickLabel',linspace(0,1,6));%,...
                        %'YAxisLocation','left','YScale','linear',...
                        %'YTick',[]);
                        %'YTick',MAX);
                else
                    set(gca,'XTick',[]);%,'YTick',[]);
                end;
                
           % subaxis(3*6,Xs*6,X*6-5,Y*6-5,1,5,'Spacing', 0,'Padding', MG,'PaddingRight',0,'PaddingBottom',0);
           %     plot(sum(JPDF'),Yax,'k');hold on;
           %     plot([0 1],[Mean1 Mean1].^Exp,'b');hold off;
                 
                if X==1;
                    ylabel('$\Phi_A$','Rotation',0);
                    set(gca,'YTick',linspace(0,1,6).^Exp,...
                        'YTickLabel',linspace(0,1,6));%,...
                        %'XTick',MAX,'XTickLabel',[]);axis([0 Max2 0 1]);
                        text(-.5,.5,['$z=$' num2str(JPDFs(Y,X).Ynorm)],'Units','Normalized',...
                                                'HorizontalAlignment','center',...
                                                'VerticalAlignment','middle',...
                                                'FontSize',11,...
                                                'Rotation',90)
                elseif (X==3 && strcmp(TitleTxt,'Re1500far'));
                    %text(1.07,.75,['$z=$' num2str(JPDFs(Y,X).Ynorm)],'Units','Normalized','Rotation',-90)
                    set(gca,'YTick',[]);%,'XTick',[]);
                elseif X==4;
                    %text(1.07,.75,['$z=$' num2str(JPDFs(Y,X).Ynorm)],'Units','Normalized','Rotation',-90)
                    set(gca,'YTick',[]);%,'XTick',[]);
                else
                    set(gca,'YTick',[]);%,'XTick',[]);
                end
        end
    end
    
   % colormap(flipud(gray));
   % axes('Position', [2*MG 3*MG 1-4*MG 1-6*MG], 'Visible', 'off');
                %Set bottom of colorbar another half tick down:
   %             cbot=3*log(Contours(1))/2-log(Contours(2))/2;
   %             ctop=log(Contours(length(Contours)));
    
   %             caxis([cbot ctop]);
   % c=colorbar ('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);


    print('-depsc','-r1200','-painters',['Vars/Eps' sprintf('%.3f', eps) '/' TitleTxt '_ConDiff_many.eps'])