<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-02
 */

class Person
{
    public $response;

    public function __construct($response)
    {
        $this->response = $response;
    }

    public function formattedResult()
    {
        $resultData = array();
        while (list(, $val) = each($this->response['results'])) {
            array_push($resultData, $this->getResultData($val));
        }
        return $resultData;
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
    private function getName($entity)
    {
        if (!empty($entity['best_name']))
            return $entity['best_name'];
        elseif (!empty($entity['name']))
            return $entity['name'];
        else
            return '';
    }

    // for person age
    private function getAge($entity)
    {
        if (!empty($entity['age_range']))
            return $entity['age_range'];
        else
            return '';
    }

    // for person contact type
    private function getContactType($entity)
    {
        if (!empty($entity['locations'])) {
            while (list(, $val) = each($entity['locations'])) {
                if (!empty($val['id'])) {
                    if ($val['id']['key'] == $this->getBestLocation($entity)) {
                        return $val['contact_type'];
                        break;
                    }
                }
            }
        } else {
            return '';
        }
    }

    private function getLocationDetails($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity)) {
            $bestLocation = $this->getBestLocation($entity);
            if (!empty($bestLocation)) {
                $location =  $this->retrieveById($bestLocation);
                return array(
                    'address_line1' => $location['standard_address_line1'],
                    'address_line2' => $location['standard_address_line2'],
                    'city' => $location['city'],
                    'postal_code' => $location['postal_code'],
                    'state_code' => $location['state_code'],
                    'country_code' => $location['country_code'],
                    'is_receiving_mail' => $location['is_receiving_mail']? 'Yes' : 'No',
                    'usage' => $location['usage'],
                    'delivery_point' => $location['delivery_point']
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
        $entity =  $this->retrieveById($id);
        return array('name' => $this->getName($entity),
            'age' => $this->getAge($entity),
            'contact_type' => $this->getContactType($entity)
        );
    }

    private function getResultData($id)
    {
        return array('person' => $this->getPersonDetails($id),
            'address' => $this->getLocationDetails($id)
        );
    }
}

