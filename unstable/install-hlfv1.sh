(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� T&Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/������|�tN7n�O��/�i� h�<^Q�D^���Q%� �/�c�F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�]ɿ�Y���4��%	���P�wo{�{�l�\�Z�9�%���}��S���p��I�&*���k��O'^���r�I�8
�"�;y?��{4%i�K��I�y�;��q��Y�����������E0��pʦ\�Fi�Fi�uH��=�E(�GH�G}�"̵�"]E|¿�>k�U�9ʐ�I�)�E����c���þԐ2���WGpbCVk"/�A���&0�Z[�Nu��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��5���M�K�o{�t���������Q��_)�(��U\�^'~����������@*�_
�^�Y���l�Z~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��A �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!e�^=ܗ� v0?�`����С�C�����������N�����5���r7�6�8Xs�+���n�b.�q�|������[K���
�4���6A(�(:�)( 2�T_#Bi���Ю/滑D���H���`��Ɗ�Q+S��_vЦ�6��0�Y�%C��#�w��f��9�[ݙ��\����� ���=!98�ģȓ�Ơ�/F^ .ԏ���4<��XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<p
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋYW2Y1��@�E#�3�^<�F�.����mx6��n�,�d��i����x�����������*��O�C	���2���������u�����Nݯv�zK qO��|h��x,fȑ8N�
��Q/!T�G��vB>$��N=��"��U�TA������^���e�$��h�``a���xvad1Ok�K��w��Dѭ\������5$B}ٚ8����������B�w�<v]�+�<s�y;hE�}?����h�4\~-C��e[�*�ቪ{@k�(ܶp=�#��4M93rր�6�����C�� �v~�Ɍ�\�A����}� ����堛��>�u�^��[��kSR�G�D������:��u�Ő�`f����d_��8�#�f5�7�~�&��� 7ؽߤی�	��97�~&׵d:\M�6��C%�u���|��d�]������!�*��|���yO��P�t���T��W�������sN���_D�T��e������?��W
���*������):�I#������8E��_�!h��Ew�e
���E� �h��H�����P��_��~��s4U�W.����=q�w4)h��Hc=A]f��\������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=���������*��|��?<���������j��Z�{������j�_9� �?*����*�+o�����o�Px$t�0�7[� -x�������]=t�0�ޭ���31��B�v�d�� *��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x�]�p�r'�v�ӳ@�D�s�m�ȸ��IG�^p ?g��qڠy����8'�9@z��%�i�V��ڹN�M�}��6Y��.,����μ����´gO&M��@�$0A����^��Y��h1	�x�� ��i��=SZ������SMG��v"FR>�9K����Ё��yW 'Y1�������)~��f�V���F�O������������\���ߵ�}����"h������B�/�b�����T�_���.���(��@Т�����%��16��EЏ:��O8C������빁���(���H��>��,IRv������_����]�e���?�	�"�Z�T��csbkL�6��s�U�����Г��b�_!��q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x��q���q���D��_� ���<��?Tu�w9�P���/3
��'�J�K�{���������r��8�V�/)����^,��5]��-���V(��������2�)���]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j����H�i;�;�?���R�;�(I<��(���2�I�����l�
e������������@���J�k�_�c���?��s Vrt�"^c	K ��o����>��gI ���1v?n���IUZ.�wIU��72���A�o>�a=:�;���@C��~صs�ā�ɧ1;�S�ż�Jw�m�=b��7��j�66a�'�E�\�n�Y=�c�1<�j2�:�޼9��\�t���[q�\R|o6h&*�n�Q�z���b��G�y��p���s��i�X�s�%_���ԕs[�(њ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>��nk�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i���}��i;�;����R�[��^��>G�P[��%ʐ�������JV翗������������k���;��4r�����>|�ǽ��O�9�b�Ql �my�>��} �{�Q��}�5�I�r�5~r��@���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&��΃����� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|���8����&���R�[�����j�OI�����9(C��Y�?��g��>���j��Z�����h��u
���?�a��?�����ww1�cBU��������+��s���X�����?�ￕ�������1%Q�q(�%\���"��� p���G	�X�
p�G(��������
e����G翐t��S
.����)�rrط̩�f�/0DhN=���l��y�-Z����?� ��q[iXW��E��5��ľ����U8QRs̡��+8��)L�Z:Yg�Q�&���F}���ش������ݹ��%q�_���?���������xS���iVX������ (�������P�����R�M#;���&��O���N:u�\�뎡n(�
�F��+{�L��g��v����_��7�ծj�t����M����`��?��ձ~z�`����=�Es����ʊ��K�k-�Ԯ��_O�Q;�w]�*J����t��^}��о/t�o4�����NΫ]9��������ڕw�m��D��1��/9���[���x/��t�7K;*f�k���*��
�3�i��W��m���VWD]�o�*�sӑ���A��~�r}��b��/��hv�oGپ�T�;?���Z��u�i�]�~�kgQ�ٗ;��AG��d�[����ͫ�Yރ(K��o`t�7��p����"{��[�2iA�ϟ�^ܻ����G���?�ٝ���nz�k����?��}���~��ǖ����5����N]��t>]�7�4�Z��d�qb�'p��p8]O6�ua�~�n��vo�>���D����8���}7A5���~�ȇ3�x�i�lNU�؆c������	d��
�8��!�"v�7��<n��#��:����M���וU��f9�}�axgkxk�p�Y�gO�:{��O�����q�*����vz.���b��m�-�����|8J'N2��8��R��8��ĉ=v�+�B*�b�?��
�� �� ?vQ+��C]!���� ��ēL���tz[�}�;��{>���_�~�9�(�[hڇ�[L�Ŧ�9�db�˕[r(!a�q(�R���e�||5<��@Wd��s�D�V:KFIhm��1�ɝ���/�e4�"����i=0-�@,���M=
D�yM:&��,� �1aZ�;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�ɀ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:��G��;����x:�����|)�eXh9�ߪ�u��t_!�-��	W����f^�9���9�XFBlQ��ܼ���F�j_4�W���Bi5^�2V5Q;5������^�M��h����t��n�t���)v8]�ɁSN���%8%������tva�k8�[�_g�� v�~SS�����Nm�h?Jx����ZהF�5�,�Z:�[�T�ͤMX����'�A�>s�ܰ�Q0G:��拰�~|A���D�R`�96����?�����74�
S0~8d.�����G�r�.���ǖ�!Ly%g�?fJA=l��=@���M(r�Z�lU�4E��F7߰:�{<KB�N_m�BK2��#��OGҎ��B����͖tM�pc�Q��;��<8r����@#�w�*�=��X��֑��2�g಄�[�q�ˌ	Z��%1�O�i]<�F��M����a�;�؇��&�r�Vu�vagk��]G�#X������5XUb����
�͛F��+�g��|�=llx�;|��8���7��Y���[��9�^��"	���;��~��O}�.�=�J�xr�{����w�!����z0�{�}?/�!�����x�@�	AL�	� 3�D�.��;r��ݗ����|��z��.<���ǟ��[����_0�yV��9���=�#_w#�y�ø8���;߸�d�>��5�s�ҿr�RcX07��N7���]i��H7�y����r9��B������� eN⵮I�ךdi��"�`d��o�1D��=Po�[*�A�Qo"U�ʽ�n	�S���
�RL��ώ9����%�9���B�d�a�N�A3�����f���s��[�%+&��"9��نn�J���|��? è�Z����!�0����dG�Ā��a��	������.K�\6?j��n�,y�R���|q�H�V�(�50�f�)!�}#���*�������#b��g􌆦��f%T�G�C�|�a�:LX�	�	���1�9a�s�zB��7��D�����R {O͍�u�PJ��lC�Ǽd0�:�I�C���ߥB�U��Tѡ���Am��x�H�R7�i$�@{
N˹(�oy�ŔB��N��47�qY,[͠\�T���D�'��%d="� ;V���d/���#|�+��i��W5��/7��d�f�6O4?و�@�qZV��ZC�7��l;n���d�RKJ<Ǒ�f$$�ر�h���='eY�낲�ys������j%8tF�QЛj	h�+�%�XPx9�	�x��Q�}�k�b�(g:r�	�����k�@�)T�Q����)�)l�(+L���2u��,��d��d������Ze��>2(�l`LSF_L����
A��^,��}�d��I�R�Ѹ^.��>�aa�I�A����A���)y(�5��^[eI�R��
e�,��%�'"�`�^M(�4��@J1��ScoZꍍva�D�Ѡ��YDH��Z�����q�Z�-� �F����S@MyO�,Q9�P����PUi��x����aK�rDxAv��p�]�?�`��CV���FyvP6ZOI>�e|tK�w[�~��C��]J)|��o,��i��ưQ��K�{-�8eq;>��9>�f>��%��n�]�]Q7�w!׶�Dv�-��{a뎝+ț�_��L>0=Cn .(���<�ȕ�<�w�W��ک��yxs��
�bW{]�~�np���i��#�
���砌�4�� r?��Q뒊2���0x��������Wٚ��^
^;F�ȏ4�F.��������c�&���[��[`��g��]}���M�=8W�+[oB����[��/lR ��ҨY-Gފ���o�\y���2��2��������eR��XL*|�:�s��X�~��:�����3q#W wY���g��sl�A{@>r�$���m�����n��8/�<w�{��`�^x��Д����D)L���hϷ�_ZxP:��mu�d�VGs��h~�а���q����V�,88s4�Y��
X��|��":�'����H��h��2�3�JkX�����iD�WB}�Ec�=#�
��N�G�F��-��TX�1J�;\���s�n�iC���q�ƒ>K�#{0q �5��,&G>B��R�<'�wcf<4KZ��33*M��A�aУ�^2uO��,�(�\+��:��ŃcB�PK�����J�Q�A=�'�l�q��;��1��Cf���YߣL/b8Ժ�ah�P���ͫ->�Fy�M����v��1�8N�c=�^�#�۠S��9���M��3�i����=�<��p/r��p���<,��w��O����?<q���-�I{�D�6}���#|����j�ԅ4o~~D,)����9|X,��h-*7Il!�"��8kPd�*0	��7kβ��������b0���Z��3�AR��ae��3$&w3��w<!��h=g�b��a	$�Z�F[���z������h���JF������!Gc!����XU��Q���B�5�J[��}���W��T���pQ��v��U��I�8���L�L�j�T�<h�Ka�0�|���=�4�?�F�9���h��]��j�R��{�4�i4+�t���{X�q8���f��~�����2艹����6
�mf۹	��v���yCnt�\W�	ݞnE�����ķ�M�V�E�8j��{����u�=-�T$vAn#�.���8��F���R�l�����{�̮_~�'/�u~���1��}�K���;>��o���{�{��@xk�O_k��s,+'��s'�?q���?>��y[��q}�������������}�����������?������O�/%�� ܺ����Z\��]јL'jԐ�����}�~����P���n�G~����?|�^b�_1ȯ稝?s#//R;�P;j�C�thM��v:_q_�_q����v���ӡv:>�㳽����[�F>�S�*7���U�=,rAS|[4���"��2�1����L��1�Gȟ߿��4GMxqx�[���O�ΧT�g��c����3�n��v�^��f���r��8�VgΌ3-���̙q��1��0g��}�0�v�̹q�a�S��6�m����s$s����-p��s8�s8�s�n��q�  