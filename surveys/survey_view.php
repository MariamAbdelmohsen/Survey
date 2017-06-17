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
$config->metaRobots = 'no index, no follow';#never index survey pages

# check variable of item passed in - if invalid data, forcibly redirect back to demo_list.php page
if(isset($_GET['id']) && (int)$_GET['id'] > 0){#proper data must be on querystring
	 $myID = (int)$_GET['id']; #Convert to integer, will equate to zero if fails
}else{
	myRedirect(VIRTUAL_PATH . "surveys/index.php");
}

$mySurvey = new SurveySez\Survey($myID); //MY_Survey extends survey class so methods can be added
if($mySurvey->isValid)
{
	$config->titleTag = "'" . $mySurvey->Title . "' Survey!";
}else{
	$config->titleTag = smartTitle(); //use constant
}
#END CONFIG AREA ----------------------------------------------------------

get_header(); #defaults to theme header or header_inc.php
?>
<h3><?=$mySurvey->Title;?></h3>

<?php

if($mySurvey->isValid)
{ #check to see if we have a valid SurveyID
	echo '<p>' . $mySurvey->Description . '</p>';
	echo $mySurvey->showQuestions();

   echo SurveySez\MY_Survey::responseList($myID);

}else{
	echo "Sorry, no such Response!";
}

if(startSession() && isset($_SESSION["AdminID"]))
		{# only admins can see 'peek a boo' link:
				 echo '<p align="center"><a href="' . VIRTUAL_PATH . 'surveys/survey_take.php?' . $_SERVER['QUERY_STRING'] . '">Take survey</a></p>';
				 echo '<p align="center"><a href="' . VIRTUAL_PATH . 'surveys/result.php?' . $_SERVER['QUERY_STRING'] . '">Result</a></p>';

		}



get_footer(); #defaults to theme footer or footer_inc.php
