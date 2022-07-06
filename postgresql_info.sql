Select version();

Select name, setting,unit, category, current_setting(name).
From  pg_settings;

Select pgs.*, current_setting(pgs.name).
From pg_file_settings pgs.
Order by pgs.name,pgs.applied, pgs.sourcefile;