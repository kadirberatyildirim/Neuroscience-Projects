%{
raster=zeros(5,401); %Initialize raster matrix
edges=[-1:.005:1]; %Define bin edges
for j=26:30 %Loop over all trials
            %Count how times fall in each bin
    raster(j,:)=histc(spike(j).times,edges);
end
figure %Create figure for plotting
imagesc(~raster ) %'B' inverts 0s and 1s
colormap('gray') %Zero plotted as black, one as white
%}


%{
for i = 128:129
    Chap17_RasterPlot(i)
    Chap17_PETH(i)
    Chap17_TuningCurve(i)
end
%}

maxx = 0;
maxx_index = 0;
for i = 1:143
    p = Chap17_TuningCurve(i);
    if p > maxx
        maxx = p;
        maxx_index = i;
    end    
end
maxx
maxx_index

Chap17_RasterPlot(maxx_index)
Chap17_PETH(maxx_index)
Chap17_TuningCurve(maxx_index)