function c = ca1_pie_colors_figures(NoiseSize, DictFile)
% creates a cell array to store in o.ClassCollapse to nicely display the
% colors of CA1 cells

% how much do individual classes vary compared to the group average
if nargin < 2
    NoiseSize = .2;
end

randn('state', 1);

% copied from change_gene_symbols
non_neuron = hsv2rgb([0 0 1]);
pc_or_in =   hsv2rgb([.4 .7 .5]);
less_active =   hsv2rgb([.3 .2 .7]);
pc =        hsv2rgb([1/3 1 1]);
pc2 =       hsv2rgb([.27 1 .7]);
in_general = hsv2rgb([2/3 1 1]);

sst =   hsv2rgb([.55 1 1]);
pvalb = hsv2rgb([.7 .8 1]);
ngf =   hsv2rgb([.85 1 1]);
cnr1 =  hsv2rgb([ 1 1 1]);
vip =   hsv2rgb([.15 1 1]);
cxcl14= hsv2rgb([.12 1 .6]);

ivy  =   hsv2rgb([.85 .5 .6]);


% import manually defined
d2 = importdata(DictFile);
d2 = cellfun(@(v) strsplit(v, ','), d2, 'uni', 0);
d2 = cat(1, d2{:});

% dictionary of colors
d = {{'Sst'}, sst ; {'Pvalb'}, pvalb ; {'IVY'}, ivy ; ...
    {'NGF'}, ngf ; {'Ntng1'}, pc_or_in; ...
    {'Cxcl14'}, cxcl14 ; {'Cck'}, cnr1; ...
    {'Calb2', 'Vip'}, vip;...
    {'PC'}, pc; {'PC other'}, pc2;...
    {'Non neuron'}, [.35 .35 .35]};

% output
c = cell(0,3);

for i=1:size(d,1)
    MyClasses = [];
    for j=1:length(d{i,1})
        MyClasses = union(MyClasses, find(strcmp(d{i,1}{j}, d2(:,3))));
    end
    showtype = d2(MyClasses, 2);
    showtype = unique(showtype, 'stable');
    
%     color_diff = sort(rand(1, length(showtype)));
    color_diff = ((1:length(showtype))-length(showtype)/2)/5;
    for j=1:length(showtype)
        cn = d2(strcmp(showtype(j), d2(:,2)), 1);
        if isstring(cn); cn = {cn}; end
        if length(showtype) == 1
            color = d{i,2};
        else
            color = d{i,2}*(1-NoiseSize/3) + NoiseSize.*color_diff(j);
%             color = d{i,2}*(1-NoiseSize) + NoiseSize.*rand(1,3);
            color(color<0) = 0; color(color>1) = 1;
        end
        c = vertcat(c, {cn, showtype{j}, color});
    end
end
c = vertcat(c, {{'Zero'}, 'Uncalled', [0 0 0]});

end


     
     
 
