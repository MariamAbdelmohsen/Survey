<?php
/**
 * survey_view.php is a page to demonstrate the proof of concept of the
 * initial SurveySez objects.
 *
 * Objects in this version are the Survey, Question & Answer objects
 *
 * @package SurveySez
 * @author William Newman
 * @version 2.12 2015/06/04
 * @link http://newmanix.com/
 * @license http://www.apache.org/licenses/LICENSE-2.0
 * @see Question.php
 * @see Answer.php
 * @see Response.php
 * @see Choice.php
 */

require '../inc_0700/config_inc.php'; #provides configuration, pathing, error handling, db credentials
spl_autoload_register('MyAutoLoader::NamespaceLoader');//required to load SurveySez namespace objects
//$config->metaRobots = 'no index, no follow';#never index survey pages

# check variable of item passed in - if invalid data, forcibly redirect back to demo_list.php page
if(isset($_GET['id']) && (int)$_GET['id'] > 0){#proper data must be on querystring
	 $myID = (int)$_GET['id']; #Convert to integer, will equate to zero if fails
}else{
	//myRedirect(VIRTUAL_PATH . "surveys/index.php");
}

$myResult = new SurveySez\Result($myID); //MY_Survey extends survey class so methods can be added
if($myResult->isValid)
{
	$config->titleTag = "'" . $myResult->Title . "' Survey!";
}else{
	$config->titleTag = smartTitle(); //use constant
}
#END CONFIG AREA ----------------------------------------------------------

get_header(); #defaults to theme header or header_inc.php
?>
<h3><?=$myResult->Title;?></h3>

<?php

if($myResult->isValid)
{ #check to see if we have a valid SurveyID
	echo "Survey Title: <b>" . $myResult->Title . "</b><br />";  //show data on page
	echo "Survey Description: " . $myResult->Description . "<br />";
	$myResult->showGraph() . "<br />";	//showTallies method shows all questions, answers and tally totals!
	unset($myResult);  //destroy object & release resources

  // echo SurveySez\MY_Survey::responseList($myID);

}else{
	echo "Sorry, no such Response!";
}




get_footer(); #defaults to theme footer or footer_inc.php
