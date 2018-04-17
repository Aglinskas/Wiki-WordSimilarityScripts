close all; clear all
%%
load('Jwiki.mat');
wiki = func_wiki_addSimMats(wiki);
%%
t = 'tomato-n'
target = func_get_Noun_clusterElements(wiki,t)
clc;
disp(target.clust)
disp(target.neighbours_string)
%%

% target_clusters_start = {39 20 [26 46] [3 43] [6 9 19] [50 22 65] [12] [61 60] [68] 66 [75 5]}
% target_clusters_lbls = {'kitchen'}
% keep_elements = 15
% c = refine_clusters2(wiki, target_clusters_start, keep_elements)
% 
% c(1).name = [];
% [c(1:size(c,2)).name] = deal(c_lbls{:})
%%
c_leg = {};l = 0;
%39 - kitchen
%20 - war
%[26 46] - disease
%[2] - visual arts
%29 - reading/writing
% 41 - luxury
% 3 43 - people/occupation
% 28 people/title
%  6 19 9 places 
% 50 musical instruments
% 50 22 65 musical ins
%  75  5 clothing items 
% 12 animals / incects pests 
%61 animals 
% 60 wild animals 
% 48 exotic animals 
% 70 reptiles 
% 68 food / domestic aninals 
% 66 = food / dishes 
%%
c_leg = {}; l = 0;
l = l+1;c_leg{l,1} = 39 ;c_leg{l,2} = 'kitchen'
l = l+1;c_leg{l,1} = 20 ;c_leg{l,2} =  'war'
l = l+1;c_leg{l,1} = [26 46] ;c_leg{l,2} =  'disease'
l = l+1;c_leg{l,1} = [2] ;c_leg{l,2} =  'visual-arts'
l = l+1;c_leg{l,1} = 29 ;c_leg{l,2} =  'reading/writing'
l = l+1;c_leg{l,1} =  41 ;c_leg{l,2} =  'luxury'
l = l+1;c_leg{l,1} =  [3 43] ;c_leg{l,2} =  'people/occupation'
l = l+1;c_leg{l,1} =  28  ;c_leg{l,2} =  'people/title'
l = l+1;c_leg{l,1} =   [6 19 9]  ;c_leg{l,2} =  'places'
l = l+1;c_leg{l,1} =  [50 22 65]  ;c_leg{l,2} =  'musical ins'
l = l+1;c_leg{l,1} =  [ 75  5]  ;c_leg{l,2} =  'clothing items'
l = l+1;c_leg{l,1} =  12  ;c_leg{l,2} =  'animals / incects pests'
l = l+1;c_leg{l,1} = 61  ;c_leg{l,2} =  'animals'
l = l+1;c_leg{l,1} =  60  ;c_leg{l,2} =  'wild animals'
l = l+1;c_leg{l,1} =  48  ;c_leg{l,2} =  'exotic animals'
l = l+1;c_leg{l,1} =  70  ;c_leg{l,2} =  'reptiles' 
l = l+1;c_leg{l,1} =  68  ;c_leg{l,2} =  'food / domestic aninals'
l = l+1;c_leg{l,1} =  66  ;c_leg{l,2} =   'food / dishes'
clear l
%%

inds = [1 3 4 5 6 7 9 10 11 12 14 15 17 18]
keep_elements = 15
target_clusters_start = c_leg(inds);
c = refine_clusters2(wiki, target_clusters_start, keep_elements)
c(1).name = []; [c(1:end).name] = deal(c_leg{inds,2})

t = {};for i = 1:length(c); t{1,i} = c(i).name;t(2:length(c(i).clust_elements_str')+1,i) = c(i).clust_elements_str';end
%%
load('Jwiki.mat')
keep_nouns = 1000;
keep_feats = 1000;
[keep_nouns_inds keep_feats_inds] = func_get_reduced_indices(wiki,keep_nouns,keep_feats)
wiki = func_slice_wiki(wiki,keep_nouns_inds,keep_feats_inds)
wiki = func_wiki_addSimMats();

disp('done')
t = func_get_Noun_clusterElements(wiki,'vest-n');
t.neighbours_string
%%
% wiki = struct;
% wiki.dm_avg     = [];
% wiki.nouns     = [];
% wiki.featwords  = [];
% wiki.sim_feat   = [];
% wiki.sim_noun   = [];
% wiki.noun_clus = [];
% wiki.noun_ord   = [];
% wiki.feat_clust = [];
% wiki.feat_ord   = [];