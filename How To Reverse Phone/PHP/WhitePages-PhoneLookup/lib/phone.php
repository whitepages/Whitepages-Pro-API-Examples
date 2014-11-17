<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-02
 */

class Phone
{
    public $entity;
    public $line_type;
    public $belongs_to;
    public $associated_locations;
    public $phone_number;
    public $country_calling_code;
    public $carrier;
    public $do_not_call;
    public $reputation;
    public $best_location;


    public function __construct($entity)
    {
        $this->entity = $entity;
        $this->line_type = $this->line_type();
        $this->belongs_to = $this->belongs_to();
        $this->associated_locations = $this->associated_locations();
        $this->phone_number = $this->phone_number();
        $this->country_calling_code = $this->country_calling_code();
        $this->carrier = $this->carrier();
        $this->do_not_call = $this->do_not_call();
        $this->reputation = $this->reputation();
        $this->best_location = $this->best_location();
    }

    public function data()
    {
        return array(
            'line_type' => $this->line_type,
            'phone_number' => $this->phone_number,
            'country_calling_code' => $this->country_calling_code,
            'carrier' => $this->carrier,
            'do_not_call' => $this->do_not_call,
            'reputation' => $this->reputation
        );
    }


    public function belongs_to()
    {
        $belongs_to_array = array();
        while (list(, $belongs_val) = each($this->entity['belongs_to'])) {
            if (!empty($belongs_val)) {
                array_push($belongs_to_array, $belongs_val['id']['key']);
            }
        }
        return $belongs_to_array;
    }

    private function line_type()
    {
        return  $this->entity['line_type'];
    }

    private function associated_locations()
    {
        $associated_locations_array = array();
        while (list(, $location_val) = each($this->entity['associated_locations'])) {
            if (!empty($location_val)) {
                array_push($associated_locations_array, $location_val['id']['key']);
            }
        }
        return $associated_locations_array;
    }

    private function phone_number()
    {
        return  $this->entity['phone_number'];
    }

    private function country_calling_code()
    {
        return  $this->entity['country_calling_code'];
    }

    private function carrier()
    {
        return  $this->entity['carrier'];
    }

    private function do_not_call()
    {
        return  $this->entity['do_not_call'];
    }

    private function reputation()
    {
        if (!empty($this->entity['reputation'])) {
            return  $this->entity['reputation']['spam_score'];
        }
    }

    private function best_location()
    {
        if (!empty($this->entity['best_location'])) {
            return  $this->entity['best_location']['id']['key'];
        }
    }
}

