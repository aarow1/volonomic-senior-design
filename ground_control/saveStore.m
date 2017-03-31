function [] = saveStore(title)
global pos_store_new quat_store time_store
t = datetime('now','Format','yyyy-MM-dd-HH-mm-ss');
filename = ['store/' char(t) '_' title '_'];
save(strcat(filename,'pos-store'),'pos_store_new');
save(strcat(filename,'quat-store'),'quat_store');
save(strcat(filename,'time-store'),'time_store');

clearStore();
    
end

