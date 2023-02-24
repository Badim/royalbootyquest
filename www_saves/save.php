<?php
	$input = ($_POST);

	$userid = preg_replace("/[^a-zA-Z0-9]+/", "", $input['user_id']);
	$pin = preg_replace("/[^0-9]+/", "", $input['pin']);
	$sid = preg_replace("/[^0-9]+/", "", $input['sid']);
	
	if($userid==null){
		echo ("error: no user id");
		return true;
	}
	if($pin=="666"){
		echo ("error: no pin");
		return true;
	}
	
	$filename = "rbq_".$userid."_".$sid."_".$pin.".txt";
	$handle2 = fopen($filename,"w+");
	
	fwrite($handle2,$input['save']); // Записываем
	fclose($handle2);
	
	echo ("uid:".$userid.", pin:".$pin);
	// echo (", pin:".$pin);
	// echo ("data:".$input['save']);
	
/*$input = ($_POST);
 
$filename = "vk_".$input['user_id'].".txt";
$text = fopen($filename, "r");
if($text)
{
	$contents = json_decode($text);
	fclose($filename);
	$handle = fopen("vk_".$input['user_id'].".txt","w+");
	$contents['money'] = $input['money'];
	fwrite($handle,json_encode($contents)); // Записываем
	fclose($handle);

}else
{
	$handle2 = fopen("vk_".$input['user_id'].".txt","w+");
	$result2 = array( 
		'money' => $input['money'] 
    ); 
	fwrite($handle2,json_encode($result2z)); // Записываем
	fclose($handle2);
};
*/
	 	 
?>