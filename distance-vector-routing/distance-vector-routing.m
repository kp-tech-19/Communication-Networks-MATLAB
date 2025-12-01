clc;clear;

n=input("Enter no. of nodes:");
fprintf("Enter the y.d x.d cost adj. matrix(Use inf for no link):\n");
cost=zeros(n,n);
for i=1:n
    for j=1:n
        if i==j
            cost(i,j)=0;
        else 
            cost(i,j)=input(sprintf("Cost of node %d to node %d:",i,j));
        end
    end
    fprintf("\n");
end
fprintf("Inital cost adj. matrix:\n")
disp(cost);

graphcost=cost;
graphcost(isinf(graphcost))=0;
G=graph(graphcost,"upper");

dist=cost;
nexthop=zeros(n,n);
updated=true;
iter=0;

while updated
    updated= false;
    iter=iter+1;
    fprintf("Iteration:%d \n",iter);
    for i=1:n
        for j=1:n
            for k=1:n
                if dist(i,k)+dist(k,j)<dist(i,j)
                    dist(i,j)=dist(i,k)+dist(k,j);
                    updated=true;
                    nexthop(i,j)=k;
                end
            end
        end
    end
end

disp("Distance Table");
disp(dist);

src=input("Enter source node:");
dest=input("Enter destination node:");

[shortestpath,totalcost]=shortestpath(G,src,dest);
disp("Shortestpath");
disp(shortestpath);

figure;
h=plot(G,"EdgeLabel",G.Edges.Weight,"Layout","force");
highlight(h,shortestpath,"Edgecolor","r","Linewidth",2);
highlight(h,shortestpath,"Nodecolor","g");
title(sprintf("Shortestpath of node %d to node %d",src,dest));

