var buildings = new Array();
var currentBuilding;
var previousBuilding;
var nextBuilding;

$(document).ready(function(){
    $(".buildingNav").click(buildingNavOptions);

    var i = 0;
    $(".building").each(function(){
        buildings[i] = parseInt($(this).attr("data-buildingNumber"), 10);
        i++;
    });

    currentBuilding = 0;
    previousBuilding = "NA";
    if(buildings.length > 1)
        nextBuilding = 1;
    else
        nextBuilding = "NA";

    $(".building").css("display","none");
    $("#building" + buildings[currentBuilding]).toggle("slide", {direction:"right"}, 600);
    $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").addClass("buildingNavSelected");
    
    
    $("#prev").click(function(){
        $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").removeClass("buildingNavSelected");

        if(previousBuilding !== "NA"){
            $("#building" + buildings[currentBuilding]).toggle("slide", {direction:"right"}, 600);
            $("#building" + buildings[previousBuilding]).delay(600).toggle("slide", {direction:"left"}, 600);
            currentBuilding--;

            if(buildings[previousBuilding - 1])
                previousBuilding--;
            else
                previousBuilding = "NA";

            if(nextBuilding === "NA")
                nextBuilding = currentBuilding + 1;
            else
                nextBuilding--;
        }
        
        
        $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").addClass("buildingNavSelected");
        buildingTarget = $("#building" + buildings[currentBuilding]);
        buildingSet(buildingTarget);
        
        updateNotes(1200);
    });

    $("#next").click(function(){
        $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").removeClass("buildingNavSelected");

        if(nextBuilding !== "NA"){
            $("#building" + buildings[currentBuilding]).toggle("slide", {direction:"left"}, 600);
            $("#building" + buildings[nextBuilding]).delay(600).toggle("slide", {direction:"right"}, 600);
            currentBuilding++;

            if(previousBuilding === "NA")
                previousBuilding = currentBuilding - 1;
            else
                previousBuilding++;

            if(buildings[nextBuilding + 1])
                nextBuilding++;
            else
                nextBuilding = "NA";
        }
        

        $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").addClass("buildingNavSelected");
        buildingTarget = $("#building" + buildings[currentBuilding]);
        buildingSet(buildingTarget);

        updateNotes(1200);
    });
    
    floorWidthSet();
    updateNotes(1200);
});


var buildingNavOptions = function(e){
    $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").removeClass("buildingNavSelected");

    var selectedBuilding = buildings.indexOf(parseInt($(e.target).attr("data-buildingNumber"), 10));
    var stageOut = "";
    var stageIn = "";
    
    if(selectedBuilding >= currentBuilding){
        stageOut = "left";
        stageIn = "right";
    }
    else{
        stageOut = "right";
        stageIn = "left";
    }
    
    
    $("#building" +buildings[currentBuilding]).toggle("slide", {direction:stageOut}, 600);
    currentBuilding = selectedBuilding;
    $("#building" +buildings[currentBuilding]).delay(600).toggle("slide", {direction:stageIn}, 600);
    

    if(buildings[currentBuilding - 1])
        previousBuilding = currentBuilding - 1;
    else
        previousBuilding = "NA";

    if(buildings[currentBuilding + 1])
        nextBuilding = currentBuilding + 1;
    else
        nextBuilding = "NA";
    
    
    $(".buildingNav[data-buildingNumber = '" + buildings[currentBuilding] + "']").addClass("buildingNavSelected");
    buildingTarget = $("#building" + buildings[currentBuilding]);
    buildingSet(buildingTarget);
    
    updateNotes(1000);
};