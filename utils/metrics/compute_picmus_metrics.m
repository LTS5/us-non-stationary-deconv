function compute_picmus_metrics(filename_list)

%-- parameters
signal_selection = 2;       %-- 1: RF | 2: IQ
pht_selection = 1;          %-- 1: numerical | 2: in_vitro_type1 | 3: in_vitro_type2 | 4: in_vitro_type3
transmission_selection = 1; %-- 1: regular | 2: dichotomous
nbPW_number = 1;            %-- An odd value between 1 and 75


%-- generate corresponding dataset filename
[filenames] = tools.generate_filenames(signal_selection,pht_selection,transmission_selection,nbPW_number);

for ii = 1:numel(filename_list)
    %-- Get the current path
    path_img = filename_list{ii};
    
    
    disp(['%%%%%%%%%%% Calculating the metrics for ', path_img, ' %%%%%%%%%%%'])
    %-- Read reconstructed image
    image = us_image();
    image.read_file(path_img);
    
    % Setup info structure
    info = tools.generate_data_info_structure(filenames.pht_name);
    
    % Create picmus metric data object
    metrics = us_picmus_metrics();
    metrics.image = image;
    metrics.scan = image.scan;
    metrics.set_data_information(info);
    metrics.flagDisplay = 1; % Set this flag to 1 to display intermediate results
    
    % Evaluate resolution and contrast
    %metrics.evaluateFWHM();
    metrics.evaluateContrast();
    
    %-- Select the right quality indicator in the metric object
    resolution = squeeze(metrics.scoreFWHM);
    contrast = metrics.scoreContrast;
    
    %-- Average axial and lateral resolution
    a_res_14(1,:) = mean(resolution(1:5,1));
    a_res_45(1,:) = mean(resolution(6:10,1));
    l_res_14(1,:) = mean(resolution(1:5,2));
    l_res_45(1,:) = mean(resolution(6:10,2));
        
    %-- Export metrics of interest
    data_format = '.mat';
    C = strsplit(path_img, data_format);
    output_filename = strcat([strjoin(C(1)), '_metrics', data_format]);
    save(output_filename, 'resolution', 'contrast', 'a_res_14', 'a_res_45', 'l_res_14', 'l_res_45');
end
end

