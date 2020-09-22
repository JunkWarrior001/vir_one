%area 100*100; width of road 20
pos=zeros(100,100);
pianyi=4;
jiankang=200;%健康人数
xiedai=0;%携带者人数
ganran=0;%感染者人数，携带者经过50单位时间后，50%概率变为感染者，50%概率恢复为健康人
sum=50;%假设被十字路口分隔的四块区域，人数各是50
ave1=[20 80];%假设被十字路口分隔的四块区域中，人群分布分别服从正态分布
ave2=[80 80];
ave3=[20 20];
ave4=[80 20];
s=[50 0;0 50];%协方差矩阵,协方差越大，生成的行人坐标越分散
r1=mvnrnd(ave1,s,sum);r1=fix(r1);%生成每块区域的行人坐标（按正态分布）
r2=mvnrnd(ave2,s,sum);r2=fix(r2);
r3=mvnrnd(ave3,s,sum);r3=fix(r3);
r4=mvnrnd(ave4,s,sum);r4=fix(r4);
r1=change(r1,1,50);r1=change(r1,2,50);r2=change(r2,1,50);r2=change(r2,2,50);r3=change(r3,1,50);r3=change(r3,2,50);r4=change(r4,1,50);r4=change(r4,2,50);
r=[r1;r2;r3;r4];
p1=0.9;%相邻4格的感染概率
p2=0.64;%对角4格的感染概率
p3=0.5;%由携带者转变为感染者的概率
t=1;
key=randi(200);
ganran=1;
jiankang=0;
xiedai=0;
index_jiankang=zeros(1,200);
index_jiankangpos=zeros(100,100);
index_ganran=zeros(1,200);
index_ganranpos=zeros(100,100);
index_xiedai=zeros(1,200);
index_xiedaipos=zeros(100,100);
tim=zeros(1,200);
tim(key)=100;
index_ganran(key)=1;
index_ganranpos(r(key,1),r(key,2))=key;
for i=1:200
    if i==key
        continue;
    end
    jiankang=jiankang+1;
    index_jiankang(i)=1;
    index_jiankangpos(r(i,1),r(i,2))=i;
end
flag=zeros(1,400);
guolu=zeros(200,1);
a=0;b=0;
ans1=0;
ans2=0;
ans3=0;
while t<=50
  [index_jiankangpos,xiedai,index_xiedai,index_xiedaipos,index_jiankang,tim,jiankang]=panduanxiedai(r,index_jiankangpos,xiedai,index_xiedai,index_xiedaipos,index_jiankang,p1,p2,tim,jiankang);
  [xiedai,index_xiedaipos,index_xiedai,ganran,index_ganran,index_ganranpos,jiankang,index_jiankang,index_jiankangpos,tim]=panduanganran(xiedai,r,index_xiedaipos,index_xiedai,ganran,index_ganran,index_ganranpos,jiankang,index_jiankang,index_jiankangpos,tim,p3);
  [r,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,guolu,flag,a,b]=move(r,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,guolu,pianyi,flag,a,b); 
  for i=1:200
      if index_jiankang(i)==0
          tim(i)=tim(i)+1;
      end
  end
  t=t+1; 
  for i=1:200
      if index_jiankang(i)
          scatter(r(i,1),r(i,2),'g');
      elseif index_xiedai(i)
          scatter(r(i,1),r(i,2),'y');
      else
          scatter(r(i,1),r(i,2),'r');
      end
      hold on
  end
  line([1,40],[40,40]);line([60,100],[40,40]);line([1,40],[60,60]);line([60,100],[60,60]);
line([40,40],[1,40]);line([40,40],[60,100]);line([60,60],[1,40]);line([60,60],[60,100]);
line([30,30],[40,60]);line([40,40],[40,60]);line([40,60],[30,30]);line([40,60],[40,40]);
line([60,60],[40,60]);line([70,70],[40,60]);line([40,60],[60,60]);line([40,60],[70,70]);
 hold off
  pause(0.00001);
  ans1=0;
  ans2=0;
  ans3=0;
  for i=1:200
      if index_jiankang(i)
          ans1=ans1+1;
      elseif index_xiedai(i)
          ans2=ans2+1;
      else 
          ans3=ans3+1;
      end
  end
end

ans=jiankang+xiedai+ganran;
function [r,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,guolu,flag,a,b]=move(r,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,guolu,pianyi,flag,a,b)
    x=zeros(200,1);
    y=zeros(200,1);
    x=r(:,1);
    y=r(:,2);
    for i=1:200
        a=x;
        if flag(i)==1
            if (x(i)<=40||x(i)>=60)&&(y(i)<=40||y(i)>=60)
            if x(i)<=40
                x(i)=max(1,r(i,1)+randi([-5,5]));
                x(i)=min(40,r(i,1)+randi([-5,5]));
            elseif x(i)>=60
                x(i)=max(60,r(i,1)+randi([-5,5]));
                x(i)=min(100,r(i,1)+randi([-5,5]));
            end
            if y(i)<=40
                y(i)=max(1,r(i,2)+randi([-5,5]));
                y(i)=min(40,r(i,2)+randi([-5,5]));
            elseif y(i)>=60
                y(i)=max(60,r(i,2)+randi([-5,5]));
                y(i)=min(100,r(i,2)+randi([-5,5]));
            end
            [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
            
            end
        end
        if guolu(i)==1
            if r(i,1)>40&&r(i,1)<60
                y(i)=r(i,2);
                x(i)=r(i,1)+randi([0,12]);
                if x(i)>=60
                    guolu(i)=0;
                    flag(i)=1;
                end
                [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
            end
            if r(i,2)>40&&r(i,2)<60
                x(i)=r(i,1);
                y(i)=r(i,2)+randi([0,12]);
                if y(i)>=60
                    guolu(i)=0;
                    flag(i)=1;
                end
                [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
            end
        end
        if guolu(i)==-1
            if r(i,1)>40&&r(i,1)<60
                y(i)=r(i,2);
                x(i)=r(i,1)-randi([0,12]);
                if x(i)<=40
                    guolu(i)=0;
                    flag(i)=1;
                end
                [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
            end
            if r(i,2)>40&&r(i,2)<60
                x(i)=r(i,1);
                y(i)=r(i,2)-randi([0,12]);
                if y(i)<=40
                    guolu(i)=0;
                    flag(i)=1;
                end
                [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
            end
        end
        if r(i,1)<=40 
            guolu(i)=0;
            x(i)=max(1,r(i,1)+randi([0,10])-pianyi);
            if ((y(i)>=30&&y(i)<=40)||(y(i)>=60&&y(i)<=70))&&x(i)>40
                guolu(i)=1;
                [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
                
            end
            x(i)=min(40,x(i));
        
        elseif r(i,1)>=60
            guolu(i)=0;
            x(i)=min(100,r(i,1)-randi([0,10])+pianyi);
            if ((y(i)>=30&&y(i)<=40)||(y(i)>=60&&y(i)<=70))&&x(i)<60
                guolu(i)=-1;
                [index_jiankangpos,index_xiedaipos,index_ganranpos]= yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
               
            end
            x(i)=max(60,x(i));
        end
        if r(i,2)<=40
            guolu(i)=0;
            y(i)=max(1,r(i,2)+randi([0,10])-pianyi);
            if ((x(i)>=30&&x(i)<=40)||(x(i)>=60&&x(i)<=70))&&y(i)>40
                guolu(i)=1;
                [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
            end
            y(i)=min(40,y(i));
        elseif r(i,2)>=60
            guolu(i)=0;
            y(i)=min(100,r(i,2)-randi([0,10])+pianyi);
            if ((x(i)>=30&&x(i)<=40)||(x(i)>=60&&x(i)<=70))&&y(i)<60
                guolu(i)=-1;
               [index_jiankangpos,index_xiedaipos,index_ganranpos]= yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
                continue;
            end
            y(i)=max(60,y(i));
        end
        [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r);
    end
    r=[x,y];
    
end
function [xiedai,index_xiedaipos,index_xiedai,ganran,index_ganran,index_ganranpos,jiankang,index_jiankang,index_jiankangpos,tim]=panduanganran(xiedai,r,index_xiedaipos,index_xiedai,ganran,index_ganran,index_ganranpos,jiankang,index_jiankang,index_jiankangpos,tim,p3)
    for i=1:200
        judge=0;
        if tim(i)>=20
            if index_ganran(i)==1
                continue;
            end
            if index_jiankang(i)==1
                continue;
            end
            judge=rand;
            if judge<0.33
                continue;
            end
            if judge>=0.33&&judge<0.5
                index_xiedai(i)=0;
                index_jiankang(i)=1;
                index_xiedaipos(r(i,1),r(i,2))=0;
                index_jiankangpos(r(i,1),r(i,2))=i;
                xiedai=xiedai-1;
                jiankang=jiankang+1;
                continue;
            end
            xiedai=xiedai-1;
            ganran=ganran+1;
            index_xiedai(i)=0;
            index_ganran(i)=1;
            index_ganranpos(r(i,1),r(i,2))=index_xiedaipos(r(i,1),r(i,2));
            index_xiedaipos(r(i,1),r(i,2))=0;
        end
    end
end
function [index_jiankangpos,xiedai,index_xiedai,index_xiedaipos,index_jiankang,tim,jiankang]=panduanxiedai(r,index_jiankangpos,xiedai,index_xiedai,index_xiedaipos,index_jiankang,p1,p2,tim,jiankang)
        for i=1:200
        if index_jiankang(i)==1
            continue;
        end
        a1=0;
        a2=0;
        b1=0;
        b2=0;
        a1=max(1,r(i,1)-1);
        a2=min(100,r(i,1)+1);
        b1=max(1,r(i,2)-1);
        b2=min(100,r(i,2)+1);
        for j=a1:a2
            for k=b1:b2
                judge=0;
                  if index_jiankangpos(j,k)&&tim(index_jiankangpos(j,k))>=20
                      continue;
                  end
                  if index_jiankangpos(j,k)
                        judge=rand;
                        if abs(j-r(i,1))+abs(k-r(i,2))==1&&judge<p1
                            index_xiedaipos(j,k)=index_jiankangpos(j,k);
                            index_xiedai(index_xiedaipos(j,k))=1;
                            tim(index_jiankangpos(j,k))=1;
                            index_jiankang(index_jiankangpos(j,k))=0;
                            index_jiankangpos(j,k)=0;
                            xiedai=xiedai+1;   
                            jiankang=jiankang-1;
                        end
                        if abs(j-r(i,1))+abs(k-r(i,2))==2&&judge<p2
                            index_xiedaipos(j,k)=index_jiankangpos(j,k);
                            index_xiedai(index_xiedaipos(j,k))=1;
                            tim(index_jiankangpos(j,k))=1;
                            index_jiankang(index_jiankangpos(j,k))=0;
                            index_jiankangpos(j,k)=0;
                            xiedai=xiedai+1;   
                            jiankang=jiankang-1;
                            end
                        end
                    end
                end
            end
        
        end
function r=change(r,a,ss)
    for i=1:ss
        if r(i,a)<0
            r(i,a)=-r(i,a);
        end
        if r(i,a)==0
            r(i,a)=1;
        end
        if r(i,a)>100
            r(i,a)=100;
        end
    end

end
function [index_jiankangpos,index_xiedaipos,index_ganranpos]=yidong(i,index_jiankang,index_jiankangpos,index_xiedai,index_xiedaipos,index_ganran,index_ganranpos,x,y,r)
    if index_jiankang(i)
        index_jiankangpos(x(i),y(i))=i;
        index_jiankangpos(r(i,1),r(i,2))=0;
        return;
    elseif index_xiedai(i)
        index_xiedaipos(x(i),y(i))=i;
        index_xiedaipos(r(i,1),r(i,2))=0;
        return;
    elseif index_ganran(i)
        index_ganranpos(x(i),y(i))=i;
        index_ganranpos(r(i,1),r(i,2))=0;
        return;
    end   
end       
            
            
            
            

    
