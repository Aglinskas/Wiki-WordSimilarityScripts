function imagesc_lbls(varargin)

switch nargin
    case 0
        error('lol at least a matrix is needed')
    case 1
        mat = varargin{1}
        disp('only matrix')
    case 2
        mat = varargin{1}
        lbls{1} = varargin{2}
        disp('sqyare matrix, 1 set of lbls')
    case 3
        mat = varargin{1}
        lbls{1} = varargin{2}
        lbls{2} = varargin{3}
        disp('matrix, 2 set of lbls')
end

lbls = {};
lbls{1} = wiki.nouns
lbls{2} = [wiki.nouns(:);wiki.nouns(:)];

imagesc(mat);
xticks(1:size(mat,2));
yticks(1:size(mat,1));

handles = {@xticklabels @yticklabels}
for i = 1:length(lbls)
    inds = find(size(mat) == length(lbls{i}));
    
end




