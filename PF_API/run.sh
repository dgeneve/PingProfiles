main()
{
echo "Loading ./subst.properties"
source ./subst.properties
echo "Updating license"
update_license
echo "Updating password"
update_password
#echo "Configuring role"
#configure_role
}
update_file()
{
echo "Updating $1 to $2 in $3"
sed -i "s|$1|$2|g" $3
}
update_license()
{
cp templates/license.template ./license.sh
update_file LICENSE_FILE $LICENSE_FILE ./license.sh
./license.sh
remove_file ./license.sh
}
update_password()
{
cp templates/password.template ./password.sh
update_file ADMIN_PW $ADMIN_PW ./password.sh
update_file ADMIN_EMAIL $ADMIN_EMAIL ./password.sh
./password.sh
remove_file ./password.sh
}
configure_role()
{
case "$ROLE" in
	IDP)
		cp templates/PFIdP.template ./PFIdP.sh
		TEMPLATE_FILE=PFIdP.sh
	;;
	SP)
		cp templates/PFSP.template ./PFSP.sh
		TEMPLATE_FILE=PFSP.sh
	;;
	BOTH)
		cp templates/PFIdpandSP.template ./PFIdpandSP.sh
		TEMPLATE_FILE=PFIdpandSP.sh
	;;
esac
update_file ADMIN_PW $ADMIN_PW ./$TEMPLATE_FILE
update_file COMPANY "$COMPANY" ./$TEMPLATE_FILE
update_file CONTACT_EMAIL "$CONTACT_EMAIL" ./$TEMPLATE_FILE
update_file FIRST_NAME "$FIRST_NAME" ./$TEMPLATE_FILE
update_file LAST_NAME "$LAST_NAME" ./$TEMPLATE_FILE
update_file PHONE "$PHONE" ./$TEMPLATE_FILE
update_file BASE_URL "$BASE_URL" ./$TEMPLATE_FILE
update_file ENTITY_ID "$ENTITY_ID" ./$TEMPLATE_FILE
./$TEMPLATE_FILE
remove_file ./$TEMPLATE_FILE
}
remove_file()
{
echo "Removing $1"
rm $1
}
main
