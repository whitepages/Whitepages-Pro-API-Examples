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
    public $entity;
    public $name;
    public $age_range;
    public $type;
    public $best_location;


    public function __construct($entity)
    {
        $this->entity = $entity;
        $this->name = $this->name();
        $this->age_range = $this->age_range();
        $this->type = $this->type();
        $this->best_location = $this->best_location();
    }

    public function data()
    {
        return array(
            'name' => $this->name,
            'type' => $this->type,
            'age_range' => $this->age_range
        );
    }

    public function best_location()
    {
        if (!empty($this->entity['best_location'])) {
            return $this->entity['best_location']['id']['key'];
        } elseif (!empty($this->entity['locations'])) {
            return $this->entity['locations'][0]['id']['key'];
        } else {
            return null;
        }
    }


    private function name()
    {
        if (!empty($this->entity['best_name'])) {
            return $this->entity['best_name'];
        } elseif (!empty($this->entity['name'])) {
            return $this->entity['name'];
        } else {
            return null;
        }
    }

    private function age_range()
    {
        if (!empty($this->entity['age_range'])) {
            return  $this->entity['age_range'];
        } else {
            return null;
        }
    }

    private function type()
    {
        if (!empty($this->entity['id'])) {
            return $this->entity['id']['type'];
        } else {
            return null;
        }
    }

}

