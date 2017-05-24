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
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� T&Y �]o�0����@B(�21��K�AI`�U��K�G˦���)���u��M��H��9���c��"M;�� B��������uY+^^��!I�P%Q��E�۩	b�vj@x���I��" �bb�8:�{����"���A�S?�I��"� y+�#��z `�Z#l�!".rֈ���v3�|�꙽nSh�Zb3$(��1$�^&�	�4�2{42�SL�C~|M��j���Á9�?8\+pԏI�2-[��9�ZjOC�5��7�V`���lb��a�N�&1����U�s5s0iP�CA��^���b4W'3����In�۩E�$��Nv�[m��u<��Ʀ�P���b\��ɨO�W����f`���e�����x�^��l��mbܕ�J���B��(6K�;�Ѯ����.�t�[��L�b�!W�j�Ua�M4"�\|�ʀ8�K&~��4p�f�J�|"��{����_�f�Z�5	ߩ,�+�J�٣Q��|��6[Q�Cu:Wu�š:���e�i� ������>�cz��Ip�]�傂j6��	-y�Ϸ<D�����A�Mp�>�������lH�i/���p7s����K���d��&��>���>�6A�
�ܨ<�.��Kv�)l�5	mz��
�<���vͱ��E)]�m���KUa�`��±��K�Pa?PAT�<�z�煼��[���D~Mȣ�]|�>��鯞����*���p8���p8���p8���p8���̗� (  