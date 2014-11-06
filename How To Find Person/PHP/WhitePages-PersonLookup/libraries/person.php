<?php

namespace Libraries;

class Person
{
    public $response;
    public $resultData;

    public function __construct($response)
    {
        $this->response = $response;
        $this->resultData = array();
    }

    public function formattedResult()
    {
        while (list(, $val) = each($this->response['results'])) {
            array_push($this->resultData, $this->getResultData($val));
        }
        return $this->resultData;
    }

    // for getting object id
    private function retrieveById($id)
    {
        if (!empty($this->response) && !empty($this->response['dictionary']) && !empty($this->response['dictionary'][$id])) {
            return $this->response['dictionary'][$id];
        } else {
            return '';
        }
    }

    // for best location id
    private function getBestLocation($entity)
    {
        if (!empty($entity['best_location']) && !empty($entity['best_location']['id'])) {
            return $entity['best_location']['id']['key'];
        } else {
            return '';
        }
    }

    // for name (business or person)
    private function getName($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['best_name']))
            return $entity['best_name'];
        elseif (!empty($entity['name']))
            return $entity['name'];
        else
            return '';
    }

    // for person age
    private function getAge($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['age_range']))
            return $entity['age_range'];
        else
            return '';
    }

    // for person contact type
    private function getContactType($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['locations'])) {
            while (list(, $val) = each($entity['locations'])) {
                if (!empty($val['id'])) {
                    if ($val['id']['key'] == $this->getBestLocation($entity)) {
                        return $contact_type = $val['contact_type'];
                        break;
                    }
                } else {
                    return '';
                }
            }
        }
    }

    private function addressLine1($entity)
    {
        return $entity['standard_address_line1'];
    }

    private function addressLine2($entity)
    {
        return $entity['standard_address_line2'];
    }

    private function getCity($entity)
    {
        return $entity['city'];
    }

    private function getPostalCode($entity)
    {
        return $entity['postal_code'];
    }

    private function getStateCode($entity)
    {
        return $entity['state_code'];
    }

    private function getCountryCode($entity)
    {
        return $entity['country_code'];
    }

    private function getReceivingMail($entity)
    {
        return $entity['is_receiving_mail'];
    }

    private function getUsage($entity)
    {
        return $entity['usage'];
    }

    private function getDeliveryPoint($entity)
    {
        return $entity['delivery_point'];
    }

    private function getLocationDetails($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity)) {
            $bestLocation = $this->getBestLocation($entity);
            if (!empty($bestLocation)) {
                $location =  $this->retrieveById($bestLocation);
                return array(
                    'address_line1' => $this->addressLine1($location),
                    'address_line2' => $this->addressLine2($location),
                    'city' => $this->getCity($location),
                    'postal_code' => $this->getPostalCode($location),
                    'state_code' => $this->getStateCode($location),
                    'country_code' => $this->getCountryCode($location),
                    'is_receiving_mail' => $this->getReceivingMail($location)? 'Yes' : 'No',
                    'usage' => $this->getUsage($location),
                    'delivery_point' => $this->getDeliveryPoint($location)
                );
            } else {
                return array();
            }
        } else {
            return array();
        }
    }

    private function getPersonDetails($id)
    {
        return array('name' => $this->getName($id),
            'age' => $this->getAge($id),
            'contact_type' => $this->getContactType($id)
        );
    }

    private function getResultData($id)
    {
        return array('person' => $this->getPersonDetails($id),
            'address' => $this->getLocationDetails($id)
        );
    }
}

