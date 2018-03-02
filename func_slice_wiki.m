function newwiki = func_slice_wiki(oldwiki,n_inds,f_inds)


newwiki = struct;
newwiki.dm_avg = oldwiki.dm_avg(n_inds,f_inds);
newwiki.nouns  = oldwiki.nouns(n_inds);
newwiki.featwords =  oldwiki.featwords(f_inds);