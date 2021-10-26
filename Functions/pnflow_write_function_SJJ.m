function []= pnflow_write_function_SJJ(image_name, pnflow_file, folder,fp, sp,...
                                       calc_box,calc_Kr, calc_I, inject_left_right,escape_left_right, res_format,rel_perm_def,...
                                       solver_params , PRS_BDRS_params, sat_convergence, visualise,rand_seed, drain_singlets)

fid =fopen([folder, '/', pnflow_file],'w');

fprintf(fid, '%s\r\n',   'TITLE');
fprintf(fid, '%s\r\n',   [image_name, '_pnflow_results']);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'SAT_CONTROL');
fprintf(fid, '%s\r\n',   [num2str(sp(1)),' ', num2str(sp(2)),' ', num2str(sp(3)),' ',num2str(sp(4)),' ',...
                         num2str(sp(5)),' ',calc_Kr, calc_I, inject_left_right, escape_left_right]);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'CALC_BOX');
fprintf(fid, '%s\r\n',   calc_box);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'INIT_CONT_ANG');
fprintf(fid, '%s\r\n',   ['1 ', num2str(fp(end-1)),' ',num2str(fp(end-1)),' 0.2 3.0 rand 0.0']);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'EQUIL_CONT_ANG');
fprintf(fid, '%s\r\n',   ['1 ', num2str(fp(end)),' ',num2str(fp(end)),' 0.2 3.0 rand 0.0']);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'RES_FORMAT');
fprintf(fid, '%s\r\n',   res_format);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'REL_PERM_DEF');
fprintf(fid, '%s\r\n',   rel_perm_def);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'SOLVER_TUNE');
fprintf(fid, '%s\r\n',   solver_params);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'PRS_BDRS');
fprintf(fid, '%s\r\n',   PRS_BDRS_params);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'FLUID');
fprintf(fid, '%s\r\n',   [num2str(fp(1)), ' ',num2str(fp(2)), ' ',num2str(fp(3)), ' ',...
                          num2str(fp(4)), ' ',num2str(fp(5)), ' ',num2str(fp(6)), ' ', num2str(fp(7))]);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   ['NETWORK F ',image_name]);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'SAT_CONVERGENCE');
fprintf(fid, '%s\r\n',   sat_convergence);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'visualize');
fprintf(fid, '%s\r\n',   visualise{1});
fprintf(fid, '%s\r\n',   visualise{2});
fprintf(fid, '%s\r\n',   visualise{3});
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'RAND_SEED');
fprintf(fid, '%s\r\n',   rand_seed);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'DRAIN_SINGLETS');
fprintf(fid, '%s\r\n',   drain_singlets);
fprintf(fid, '%s\r\n',   '#');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   '');

fclose(fid);

end