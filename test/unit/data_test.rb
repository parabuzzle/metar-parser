#!/usr/bin/env ruby
# encoding: utf-8

require File.dirname(__FILE__) + '/../metar_test_helper'

class TestMetarData < Test::Unit::TestCase
  
  def setup
  end

  # Temperature
  def test_temperature_parse_blank_gives_nil
    temperature = Metar::Temperature.parse('')
    assert_nil(temperature)
  end

  def test_temperature_parse_incorrect_gives_nil
    temperature = Metar::Temperature.parse('XYZ')
    assert_nil(temperature)
  end

  def test_temperature_parse_positive
    temperature = Metar::Temperature.parse('12')
    assert_equal(12, temperature.value)
  end

  def test_temperature_parse_negative
    temperature = Metar::Temperature.parse('M12')
    assert_equal(-12, temperature.value)
  end

  # Speed
  def test_speed_parse_blank_gives_nil
    speed = Metar::Speed.parse('')
    assert_nil(speed)
  end

  def test_speed_parse_default_unit
    speed = Metar::Speed.parse('12')
    assert_equal(12, speed.value)
    assert_equal(:kilometers_per_hour, speed.unit)
  end

  def test_speed_parse_kilometers_per_hour
    speed = Metar::Speed.parse('12KMH')
    assert_equal(12, speed.value)
    assert_equal(:kilometers_per_hour, speed.unit)
  end

  def test_speed_parse_knots
    speed = Metar::Speed.parse('12KT')
    assert(:knots, speed.unit)
  end

  def test_speed_parse_meters_per_second
    speed = Metar::Speed.parse('12MPS')
    assert_equal(:meters_per_second, speed.unit)
  end

  # Visibility
  def test_visibility_parse_blank
    visibility = Metar::Visibility.parse('')
    assert_nil(visibility)
  end

  def test_visibility_parse_comparator_defaults_to_nil
    visibility = Metar::Visibility.parse('0200NDV')
    assert_nil(visibility.comparator)
  end

  def test_visibility_parse_9999
    visibility = Metar::Visibility.parse('9999')
    assert_equal('more than 10 kilometers', visibility.to_s)
  end

  def test_visibility_parse_ndv
    visibility = Metar::Visibility.parse('0200NDV')
    assert_equal(200, visibility.distance.value)
    assert_nil(visibility.direction)
  end

  def test_visibility_parse_us_fractions_1_4
    visibility = Metar::Visibility.parse('1/4SM')
    assert_equal(Metar::Distance.miles(0.25), visibility.distance.value)
    assert_equal(:miles, visibility.distance.options[:units])
  end

  def test_visibility_parse_us_fractions_2_1_2
    visibility = Metar::Visibility.parse('2 1/2SM')
    assert_equal(Metar::Distance.miles(2.5), visibility.distance.value)
    assert_equal(:miles, visibility.distance.options[:units])
  end

  def test_visibility_parse_kilometers
    visibility = Metar::Visibility.parse('5KM')
    assert_equal(5000.0, visibility.distance.value)
    assert_equal(:kilometers, visibility.distance.options[:units])
  end

  def test_visibility_parse_compass
    visibility = Metar::Visibility.parse('5NE')
    assert_equal(5000.0, visibility.distance.value)
    assert_equal(:kilometers, visibility.distance.options[:units])
    assert_equal(45.0, visibility.direction.value)
    visibility.distance.options[:units] = :kilometers
    visibility.distance.options[:abbreviated] = true
    visibility.distance.options[:decimals] = 0
    visibility.direction.options[:units] = :compass
    assert_equal('5km NE', visibility.to_s)
  end
end
