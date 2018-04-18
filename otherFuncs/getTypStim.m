
dendro=squeeze(mean(dmAll));


dendro=log(dendro+1);

fruits={'Pumpkin','Apricot','avocado','banana','cranberry','Cherry','coconut','date','pear','grapefruit','kiwi','guava','lemon','files','mango','melon','nectarine','nut','olive','khaki','fishing','pear','pickle','pineapple','plum','pomegranate','kumquat','raisins','raspberry','strawberry','Mandarin','tomato'};
tools={'square','meter','ruler','screwdriver','drill','nail','stand','level','plane','chisel','file','rasp','pencil','gripper','tong','scale','screw','punch','zip','chalk','die','bolt','broom','anvil','glue','brush','stapler','welding','wheelbarrow','ax','concrete','scissors'};
clothes={'pants','shirt','dress','gonna','blouse','necklace','tank','jacket','coat','sweater','hoody','underpants','socks','panties','socks','pajamas','bathrobe','shoes','smoking','cape','boots','shoes','tie','corset','belt','scarf','mittens','slippers','hat','gloves','apron','earmuffs'};
mammals={'Armadillo','sloth','goat','Beaver','wildboar','Rabbit','coyotes','hamster','weasel','ant','gazelle','hyena','koala','lemur','lion','hare','lynx','otter','pig','groundhog','platypus','Panther','sheep','raccoon','skunk','hedgehog','monkey','squirrel','mole','tiger','fox','zebra'};
birds={'Heron','lark','duck','Eagle','vulture','canary','Stork','Swan','dove','Raven','Pheasant','hawk','flamingo','seagull','hummingbird','rooster','magpie','owl','buzzard','goose','parrot','sparrow','Peacock','pelican','robin','pecker','pigeon','penguin','quail','bat','ostrich','turkey'};


allStim=lower({fruits{1:32} tools{1:32} clothes{1:32} mammals{1:32} birds{1:32}});
keep=[];
for ii=1:length(allStim)
   x=find(strcmp(allStim{ii},label));
   try
   keep(ii,:)=dendro(x,:);
   end
end

killer=find(sum(keep')==0);
keep(killer,:)=[];
allStim(killer)=[];
keep=keep./repmat(mean(keep')',1,size(keep,2));
%%
keep=corr(keep');
Y=[];
cc=0;for ii=1:size(keep,1);for jj=ii+1:size(keep,2),cc=cc+1;Y(cc)=keep(ii,jj);end;end
Z=linkage(1-Y, 'ward');%,{'correlation'} )
  [H,T,OUTPERM] =dendrogram(Z,length(Z),'Labels',allStim,'Colorthresh',1.5);