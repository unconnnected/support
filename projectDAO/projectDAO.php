<?php

/**
 * 
 * @author Paul Bennett
 * @copyright Copyright (c) 2013 Bennett Media
 * All rights reserved
 * @version 
 * 1.0 Build document
 */

/**
 * Interface for project DAO
 *  
 */

interface projectDAO {

    public function getAllProjects();
    
    public function getLastProject();
    
    public function getProjectByProjectId($projectId = null);
    
    public function getProjectByProjectHtmlLink($projectHtmlLink = null);
    
    public function getProjectsByUserId($userId = null);
    
    public function loadProject($results);
    
    public function loadProjectList($results);
    
    public function insertProject($userId = null, $projectName = null, $projectHtmlLink = null);

    public function updateProject($projectId = null, $projectName = null, $projectNote = null);
    
    public function updateProjectName($projectId = null, $projectName = null);
    
    public function updateProjectHtmlLink($projectId = null, $projectHtmlLink = null);
    
    public function copyProjectByProjectId($projectId = null);
    
    public function deleteProject($projectId = null);
}
?>