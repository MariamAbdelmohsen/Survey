<?php
/**
* result_test.php shows the results of a Survey, indicating tallied answers
 *
 * Will attempt to create a Result 'object' to create an array of Result objects,
 * and show total tallies of answer
 *
 * This is a test page to prove the concept of returning Result data, with
 * internal Result object data
 *
 * @package SurveySez
 * @author Bill Newman <williamnewman@gmail.com>
 * @version 2.0 2009/11/10
 * @link http:# www.billnsara.com/advdb/
 * @license http:// opensource.org/licenses/osl-3.0.php Open Software License ("OSL") v. 3.0
 * @see Result_inc.php
 * @see Result_inc.php
 * @see Survey_inc.php
 * @todo none
 */

require '../inc_0700/config_inc.php'; #provides configuration, pathing, error handling, db credentials

# currently 'hard wired' to one Result - will need to pass in #id of a Result on the qstring
spl_autoload_register('MyAutoLoader::NamespaceLoader');//required to load SurveySez namespace object

if(isset($_GET['id']) && (int)$_GET['id'] > 0){#proper data must be on querystring
	 $myID = (int)$_GET['id']; #Convert to integer, will equate to zero if fails
}else{
	myRedirect(VIRTUAL_PATH . "surveys/index.php");
}


$myResult = new SurveySez\Result(1);
if($myResult->isValid)
{
	$PageTitle = "'Result to " . $myResult->Title . "' Survey!";
}else{
	$PageTitle = THIS_PAGE; #use constant
}
$config->titleTag = $PageTitle;

#END CONFIG AREA ----------------------------------------------------------

get_header(); # defaults to header_inc.php
?>
<h2><?php print THIS_PAGE; ?></h2>
<?php

if($myResult->isValid)
{# check to see if we have a valid SurveyID
	echo "Survey Title: <b>" . $myResult->Title . "</b><br />";  //show data on page
	echo "Survey Description: " . $myResult->Description . "<br />";
	$myResult->showGraph() . "<br />";	//showTallies method shows all questions, answers and tally totals!
	unset($myResult);  //destroy object & release resources
}else{
	echo "Sorry, no results!";
}

get_footer(); #defaults to footer_inc.php

?>
