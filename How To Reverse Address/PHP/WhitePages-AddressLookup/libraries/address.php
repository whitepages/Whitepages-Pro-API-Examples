<?php

namespace Libraries;

class Address
{
    public $response;
    public $resultData;

    public function __construct($params)
    {
        $this->response = $params;
        $this->resultData = array();
    }

    // for getting object id
    public function retrieveById($id)
    {
        if (!empty($this->response) && !empty($this->response['dictionary']) && !empty($this->response['dictionary'][$id])) {
            return $this->response['dictionary'][$id];
        }
    }

    // for best location id
    public function getBestLocation($entity)
    {
        if (!empty($entity)) {
            if (!empty($entity['best_location']) && !empty($entity['best_location']['id']) && $entity['id']['type'] == 'Person') {
                return $entity['best_location']['id']['key'];
            } elseif (!empty($entity['locations']) && $entity['id']['type'] != 'Person') {
                return $entity['locations'][0]['id']['key'];
            }
        }
    }

    // for name (business or person)
    public function getName($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['best_name'])) {
            return $entity['best_name'];
        } elseif (!empty($entity['name'])) {
            return $entity['name'];
        }
    }

    // for person age
    public function getAge($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['age_range'])) {
            return $entity['age_range'];
        }
    }

    // for person contact type
    public function getContactType($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['locations'])) {
            while (list(, $val) = each($entity['locations'])) {
                if (!empty($val['id'])) {
                    if ($val['id']['key'] == $this->getBestLocation($entity)) {
                        return $contact_type = $val['contact_type'];
                        break;
                    }
                }
            }
        }
    }


    // getting legal entities (people id)
    public function getPersons($id)
    {
        $entity =  $this->retrieveById($id);
        $personDetailArray = array();
        if (!empty($entity['legal_entities_at'])) {
            while (list(, $val) = each($entity['legal_entities_at'])) {
                if (!empty($val['id'])) {
                    array_push($personDetailArray, $this->getPersonDetails($val['id']['key']));
                }
            }
        }
        return $personDetailArray;
    }

    public function getLocationDetails($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity)) {
            return array('address_line1' => $entity['standard_address_line1'],
                'address_line2' => $entity['standard_address_line2'],
                'city' => $entity['city'],
                'postal_code' => $entity['postal_code'],
                'state_code' => $entity['state_code'],
                'country_code' => $entity['country_code'],
                'is_receiving_mail' => $entity['is_receiving_mail']? 'Yes' : 'No',
                'usage' => $entity['usage'],
                'delivery_point' => $entity['delivery_point']);
        }

    }

    public function getPersonDetails($id)
    {
        return array('name' => $this->getName($id),
            'age' => $this->getAge($id),
            'contact_type' => $this->getContactType($id)
        );
    }

    public function getResultData($id)
    {
        return array('location' => $this->getLocationDetails($id),
            'people' => $this->getPersons($id)
        );
    }

    public function formattedResult()
    {
        while (list(, $val) = each($this->response['results'])) {
            array_push($this->resultData, $this->getResultData($val));
        }
        return $this->resultData;
    }
}

