<?php
/**
 * survey_list.php along with survey_view.php provides a sample web application
 *
 * The difference between demo_list.php and survey_list.php is the reference to the
 * Pager class which processes a mysqli SQL statement and spans records across multiple
 * pages.
 *
 * The associated view page, survey_view.php is virtually identical to demo_view.php.
 * The only difference is the pager version links to the list pager version to create a
 * separate application from the original list/view.
 *
 * @package SurveySez
 * @author Joe Blow <joe@example.com>
 * @version 1.0 2017/05/04
 * @link http://www.example.com/
 * @license http://www.apache.org/licenses/LICENSE-2.0
 * @see survey_view.php
 * @see Pager.php
 * @todo none
 */

# '../' works for a sub-folder.  use './' for the root
require '../inc_0700/config_inc.php'; #provides configuration, pathing, error handling, db credentials

# SQL statement
//$sql = "select MuffinName, MuffinID, Price from test_Muffins";
//$sql = "select SurveyID,Title,Description,DateAdded,LastUpdated from sp17_surveys";
//$sql = "select *  FROM sp17_surveys , sp17_Admin ";
$sql = "select CONCAT(a.FirstName, ' ', a.LastName) AdminName, s.SurveyID, s.Title, s.Description,
date_format(s.DateAdded, '%W %D %M %Y %H:%i') 'DateAdded' from ". PREFIX . "surveys s,
 " . PREFIX . "Admin a where s.AdminID=a.AdminID ";

#Fills <title> tag. If left empty will default to $PageTitle in config_inc.php
$config->titleTag = 'Surveys made with love & PHP in Seattle';

#Fills <meta> tags.  Currently we're adding to the existing meta tags in config_inc.php
$config->metaDescription = 'Seattle Central\'s ITC250 Class Surveys are made with pure PHP! ' . $config->metaDescription;
$config->metaKeywords = 'Surveys,PHP,Fun,Bran,Regular,Regular Expressions,'. $config->metaKeywords;

/*
$config->metaDescription = 'Web Database ITC281 class website.'; #Fills <meta> tags.
$config->metaKeywords = 'SCCC,Seattle Central,ITC281,database,mysql,php';
$config->metaRobots = 'no index, no follow';
$config->loadhead = ''; #load page specific JS
$config->banner = ''; #goes inside header
$config->copyright = ''; #goes inside footer
$config->sidebar1 = ''; #goes inside left side of page
$config->sidebar2 = ''; #goes inside right side of page
$config->nav1["page.php"] = "New Page!"; #add a new page to end of nav1 (viewable this page only)!!
$config->nav1 = array("page.php"=>"New Page!") + $config->nav1; #add a new page to beginning of nav1 (viewable this page only)!!
*/

# END CONFIG AREA ----------------------------------------------------------

get_header(); #defaults to theme header or header_inc.php
?>
<h3 align="center">Surveys</h3>

<?php
#reference images for pager
$prev = '<img src="' . VIRTUAL_PATH . 'images/arrow_prev.gif" border="0" />';
$next = '<img src="' . VIRTUAL_PATH . 'images/arrow_next.gif" border="0" />';

# Create instance of new 'pager' class
$myPager = new Pager(10,'',$prev,$next,'');
$sql = $myPager->loadSQL($sql);  #load SQL, add offset

# connection comes first in mysqli (improved) function
$result = mysqli_query(IDB::conn(),$sql) or die(trigger_error(mysqli_error(IDB::conn()), E_USER_ERROR));

if(mysqli_num_rows($result) > 0)
{#records exist - process
	if($myPager->showTotal()==1)
  {$itemz = "survey";}
  else{$itemz = "surveys";}  //deal with plural


    echo '<div align="center">We have ' . $myPager->showTotal() . ' ' . $itemz . '!</div>';
echo'
<div class="visible-sm.visible-xs">
<table class="table table-striped table-hover table-responsive  ">
  <thead>
    <tr>
    <th>AdminName</th>
      <th>Title</th>
      <th>Description</th>
      <th>DateAdded</th>
    </tr>
  </thead>
  <tbody>

  ';

  while($row = mysqli_fetch_assoc($result))
	{# process each row

  echo'
  <tr>
    <td>' . dbOut($row['AdminName']) . ' </td>
    <td><a href="' . VIRTUAL_PATH . 'surveys/survey_view.php?id=' . (int)$row['SurveyID'] . '">
    ' . dbOut($row['Title']) . ' </a></td>
    <td>' . dbOut($row['Description']) . ' </td>
    <td>' . dbOut($row['DateAdded']) . ' </td>

  </tr>
  ';
        //  echo '<div align="center"><a href="' . VIRTUAL_PATH . 'surveys/survey_view.php?id=' . (int)$row['SurveyID'] . '">' . dbOut($row['Discription']) . ' ' . dbOut($row['Title']) . '
				//  ' . dbOut($row['DateAdded']) . ' ' . dbOut($row['AdminName']) . ' </a>';
				// // echo '<div align="center"><a href="' . VIRTUAL_PATH . 'surveys/survey_view.php?id=' . (int)$row['AdminID'] . '">' . dbOut($row['FirstName']) . ' ' . dbOut($row['LastName']) . ' </a>';

         echo '</div>';
	}


  echo'
  </tbody>
</table>
</div>
';
	echo $myPager->showNAV(); # show paging nav, only if enough records
}else{#no records
    echo "<div align=center>There are currently no surveys</div>";
}
@mysqli_free_result($result);

get_footer(); #defaults to theme footer or footer_inc.php
?>