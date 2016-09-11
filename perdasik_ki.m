  function [loss sik sik2] = perdasik_ki(ik_ki)

 n=ik_ki;
 mpc=loadcase('rede5barr');
 mpopt = mpoption('out.all',0,'verbose',0,'out.force',0);
 I=mpc.branch(:,1);
 K=mpc.branch(:,2);
 if n==1
    mpc.branch(:,1)=I(:,1) 
    mpc.branch(:,2)=K(:,1)
    results= runopf(mpc,mpopt); 
    loss = get_losses(results);
  elseif n==2
    mpc.branch(:,1)=K(:,1) 
    mpc.branch(:,2)=I(:,1)   
    results= runopf(mpc,mpopt);
    loss = get_losses(results);
    
 end
 if n==1
[~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, S, S2]= transito_difuso(2)
 else
     [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, S, S2]= transito_difuso(1)
 end
 sik = S;
 sik2 = S2;
end
