<?php

/**
 * 
 * @author Paul Bennett
 * @copyright Copyright (c)
 * All rights reserved
 * @version 
 * 1.0 Build document
 */

/**
 * Implementation of project DAO
 * 
 */

    require_once Config::getClassDir().'/dao/projectDAO.php';
    require_once Config::getClassDir().'/daoImp/coreDAOImp.php';
    require_once Config::getClassDir().'/bean/project.php';
    
class projectDAOImp extends coreDAOImp implements projectDAO{

    public function getAllProjects(){
        $query ="select * from projects order by modified_time desc;";
        $results = $this->singleQueryDatabase($query);
        $projectList = $this->loadProjectList($results);
        return $projectList;
    }
    
    public function getLastProject(){
        $query = "select * from projects order by id desc limit 1;";
        $results = $this->singleQueryDatabase($query);
        $project = $this->loadProject($results);
        return $project;
    }
    
    public function getProjectByProjectId($projectId = null){
        if(!is_null($projectId)):
            $query = "select * from projects where id = ".$projectId.";";
            $results = $this->singleQueryDatabase($query);
            $project = $this->loadProject($results);
            return $project;
        endif;
        
        return null;
    }
    
    public function getProjectByProjectHtmlLink($projectHtmlLink = null){
        if(!is_null($projectHtmlLink)):    
            $query = "select * from projects where project_html_link = '".$projectHtmlLink."';";
            $results = $this->singleQueryDatabase($query);
            $project = $this->loadProject($results);
            return $project;
        endif;
        
        return null;
    }
    
    public function getProjectsByUserId($userId = null){
        if(!is_null($userId)):    
            $query = "select * from projects where user_id = ".$userId." order by modified_time desc;";
            $results = $this->singleQueryDatabase($query);
            $projectList = $this->loadProjectList($results);
            return $projectList;
        endif;
        
        return null;
    }
    
     /**
     * @param type $results
     * @return project 
     * 
     * Single row answers. Returns single object.
     *  
     */
    
    public function loadProject($results){
        if(!mysqli_num_rows($results)==0){  
            $project = new project();
            
            while($row = mysqli_fetch_array($results)){
                $project->setProjectId($row['id']);
                $project->setUserId($row['user_id']);
                $project->setProjectName($row['project_name']);
                $project->setProjectNote($row['project_note']);
                $project->setProjectHtmlLink($row['project_html_link']);
                $project->setCreatedTime($row['created_time']);
                $project->setModifiedTime($row['modified_time']);
            }       
            mysqli_free_result($results);
            return $project;
        }        
        else
            return null;
    }

    /**
     * @param type $results
     * @return projectList 
     * 
     * Multiple row answers. Returns array of objects.
     * 
     */
    
    public function loadProjectList($results){
        if(!mysqli_num_rows($results)==0){ 
            $projectList = array();
            $count = 0;
            
            while($row = mysqli_fetch_array($results)){
                $project = new project();
                $project->setProjectId($row['id']);
                $project->setUserId($row['user_id']);
                $project->setProjectName($row['project_name']);
                $project->setProjectNote($row['project_note']);
                $project->setProjectHtmlLink($row['project_html_link']);
                $project->setCreatedTime($row['created_time']);
                $project->setModifiedTime($row['modified_time']);
                $projectList[$count] = $project;
                $count++;
            }       
            mysqli_free_result($results);
            return $projectList;
        }        
        else
            return null;        
    }

    public function insertProject($userId = null, $projectName = null, $projectHtmlLink = null){
        if(!is_null($userId) && !is_null($projectName) && !is_null($projectHtmlLink)):
            $query = "insert into projects (id, user_id, project_name, project_note, project_html_link, created_time, modified_time)";
            $query.= " values (null, ".$userId.", '".$projectName."', '', '".$projectHtmlLink."', NOW(), NOW());";
            $results = $this->singleQueryDatabase($query);
            return $results;
        endif;
        
        return null;
    }
    
    public function updateProject($projectId = null, $projectName = null, $projectNote = null){
        if(!is_null($projectId) && !is_null($projectName) && !is_null($projectNote)):
            $query = "update projects set project_name = '".$projectName."', project_note = '".$projectNote."', modified_time = NOW() where id = ".$projectId.";";
            $results = $this->singleQueryDatabase($query);
            return $results;     
        endif;
        
        return null;
    }
    
    public function updateProjectName($projectId = null, $projectName = null){
        if(!is_null($projectId) && !is_null($projectName)):    
            $query = "update projects set project_name = '".$projectName."', modified_time = NOW() where id = ".$projectId.";";
            $results = $this->singleQueryDatabase($query);
            return $results;
        endif;
        
        return null;
    }
    
    public function updateProjectHtmlLink($projectId = null, $projectHtmlLink = null){
        if(!is_null($projectId) && !is_null($projectHtmlLink)):
            $query = "update projects set project_html_link = '".$projectHtmlLink."', modified_time = NOW() where id = ".$projectId.";";
            $results = $this->singleQueryDatabase($query);
            return $results;
        endif;
        
        return null;
    }
    
    public function copyProjectByProjectId($projectId = null){
        if(!is_null($projectId)):
            $query = "create temporary table tmptable_".$projectId." select * from projects where id = ".$projectId.";";
            $query.= " update tmptable_".$projectId." set id = null, created_time = NOW(), modified_time = NOW();";
            $query.= " insert into projects select * from tmptable_".$projectId.";";
            $query.= " drop temporary table if exists tmptable_".$projectId.";";
            $results = $this->multiQueryDatabase($query);
            return $results;
        endif;
        
        return null;
    }
    
    public function deleteProject($projectId = null){
        if(!is_null($projectId)):
            $query = "delete from projects where id = ".$projectId." limit 1;";
            $results = $this->singleQueryDatabase($query);
            return $results;
        endif;
        
        return null;
    }
}
?>
