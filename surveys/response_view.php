<?php
/**
 * response_test.php shows an entire response, after it has been created
 *
 * Will attempt to create a response 'object' to store user entered response data.
 *
 * This is a test page to prove the concept of storage of Response data, with
 * internal Question, Answer and Choice object data
 *
 * @package SurveySez
 * @author William Newman
 * @version 2.1 2015/05/28
 * @link http://newmanix.com/
 * @license http://www.apache.org/licenses/LICENSE-2.0
 * @see Response.php
 * @see Choice.php
 */

require '../inc_0700/config_inc.php'; #provides configuration, pathing, error handling, db credentials
spl_autoload_register('MyAutoLoader::NamespaceLoader');//required to load SurveySez namespace objects

# check variable of item passed in - if invalid data, forcibly redirect back to demo_list.php page
// if(isset($_GET['id']) && (int)$_GET['id'] > 0){#proper data must be on querystring
// 	 $myID = (int)$_GET['id']; #Conv	ert to integer, will equate to zero if fails
// }else{
// 	//myRedirect(VIRTUAL_PATH . "surveys/index.php");
// 	header('Location:survey_view.php');
//
// }



if(isset($_GET['id']) && (int)$_GET['id'] > 0){#proper data must be on querystring
	 $myID = (int)$_GET['id']; #Convert to integer, will equate to zero if fails
}else{
	myRedirect(VIRTUAL_PATH . "surveys/index.php");
}

# currently 'hard wired' to one response - will need to pass in #id of a Response on the qstring
$myResponse = new SurveySez\Response($myID);
if($myResponse->isValid)
{
	$PageTitle = $myResponse->Title . " Survey Response!";
	//$config->titleTag = "'" . $myResponse->Title . "' Survey Response!";
// }else{
// 	$config->titleTag = smartTitle(); //use constant
// }
}else{
	$PageTitle = THIS_PAGE; #use constant
}
$config->titleTag = $PageTitle;
#END CONFIG AREA ----------------------------------------------------------

get_header(); # defaults to header_inc.php
?>
<h2><?=$myResponse->Title;?></h2>
<!-- <h3 align="center"><?=$config->titleTag;?></h3> -->

<?php

if($myResponse->isValid)
{# check to see if we have a valid SurveyID
	echo "Survey Title: <b>" . $myResponse->Title . "</b><br />";  # show data on page
	echo "Date Taken: " . $myResponse->DateTaken . "<br />";
	echo "Survey Description: " . $myResponse->Description . "<br />";
	echo "Number of Questions: " .$myResponse->TotalQuestions . "<br /><br />";
	echo $myResponse->showChoices() . "<br />";	# showChoices method shows all questions, and selected answers (choices) only!
	unset($myResponse);  # destroy object & release resources
}else{
	echo "Sorry, no such response!";
}
echo '<p align="center"><a href="' . VIRTUAL_PATH . 'surveys/result.php?' . $_SERVER['QUERY_STRING'] . '">Result</a></p>';


if (isset($_SERVER['HTTP_REFERER']))
 echo '<a href="'.htmlspecialchars($_SERVER['HTTP_REFERER']).'">Go Back</a>';
get_footer(); #defaults to footer_inc.php

?>
