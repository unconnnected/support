<?php

/**
 * 
 * @author Paul B
 * @copyright Copyright (c) 
 * All rights reserved
 * @version 
 * 1.0 Build document
 */

/**
 * Project bean object
 * 
 */

final class project {

    protected $projectId;
    protected $userId;
    protected $projectName;
    protected $projectNote;
    protected $projectHtmlLink;
    protected $createdTime;
    protected $modifiedTime;

    public function getProjectNote() {
        return $this->projectNote;
    }

    public function setProjectNote($projectNote) {
        $this->projectNote = $projectNote;
    }

    public function getProjectId() {
        return $this->projectId;
    }

    public function setProjectId($projectId) {
        $this->projectId = $projectId;
    }

    public function getUserId() {
        return $this->userId;
    }

    public function setUserId($userId) {
        $this->userId = $userId;
    }

    public function getProjectName() {
        return $this->projectName;
    }

    public function setProjectName($projectName) {
        $this->projectName = $projectName;
    }

    public function getProjectHtmlLink() {
        return $this->projectHtmlLink;
    }

    public function setProjectHtmlLink($projectHtmlLink) {
        $this->projectHtmlLink = $projectHtmlLink;
    }

    public function getCreatedTime() {
        return $this->createdTime;
    }

    public function getCreatedTimeBritishFormat(){
        $datetime = strtotime($this->createdTime);
        return date('d-m-Y', $datetime);
    }
    
    public function setCreatedTime($createdTime) {
        $this->createdTime = $createdTime;
    }

    public function getModifiedTime() {
        return $this->modifiedTime;
    }

    public function getModifiedTimeBritishFormat(){
        $datetime = strtotime($this->modifiedTime);
        return date('d-m-Y', $datetime);
    }
    
    public function setModifiedTime($modifiedTime) {
        $this->modifiedTime = $modifiedTime;
    }

    public function __toString() {
        return 'Project Object id:'.$this->getProjectId().' userid:'.$this->getUserId().' projectname:'.$this->getProjectName().' projectnote:'.$this->getProjectNote().' projecthtmllink:'.$this->getProjectHtmlLink().' createdtime:'.$this->getCreatedTime().' modifiedtime:'.$this->getModifiedTime();
    }
}
?>
