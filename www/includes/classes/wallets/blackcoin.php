<?php
require_once('abstract.php');
/*
 * @author Stoyvo
 */
class Wallets_Blackcoin extends Wallets_Abstract {

    public function __construct($label, $address) {
        parent::__construct($label, $address);
        $this->_apiURL = 'http://chainz.cryptoid.info/blk/api.dws?q=getbalance&key=6e1508c63640&a=' . $address;
        $this->_fileHandler = new FileHandler('/config/user_data/wallets/blackcoin/' . $this->_address . '.json');
    }

    public function update() {
        if ($GLOBALS['cached'] == false || $this->_fileHandler->lastTimeModified() >= 3600) { // updates every 60 minutes.
            $addressBalance = curlCall($this->_apiURL);

            $data = array (
                'label' => $this->_label,
                'address' => $this->_address,
                'balance' => (float) $addressBalance
            );

            $this->_fileHandler->write(json_encode($data));
            return $data;
        }

        return json_decode($this->_fileHandler->read(), true);
    }

}
