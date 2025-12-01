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

dist=zeros(n,n);
nexthop=zeros(n,n);


for i=1:n
    dist(i,:)=distances(G,i);
    for j=1:n
        if i~=j && isfinite(dist(i,j))
            path=shortestpath(G,i,j);
            if numel(path)>1
                nexthop=path(2);
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


