import { Converter } from '../src/converter';

describe('Converter', () => {
  describe('convertTemperature', () => {
    test('should convert celsius to fahrenheit', () => {
      expect(Converter.convertTemperature(0, 'celsius', 'fahrenheit')).toBeCloseTo(32);
      expect(Converter.convertTemperature(100, 'celsius', 'fahrenheit')).toBeCloseTo(212);
      expect(Converter.convertTemperature(-40, 'celsius', 'fahrenheit')).toBeCloseTo(-40);
    });

    test('should convert celsius to kelvin', () => {
      expect(Converter.convertTemperature(0, 'celsius', 'kelvin')).toBeCloseTo(273.15);
      expect(Converter.convertTemperature(100, 'celsius', 'kelvin')).toBeCloseTo(373.15);
      expect(Converter.convertTemperature(-273.15, 'celsius', 'kelvin')).toBeCloseTo(0);
    });

    test('should convert fahrenheit to celsius', () => {
      expect(Converter.convertTemperature(32, 'fahrenheit', 'celsius')).toBeCloseTo(0);
      expect(Converter.convertTemperature(212, 'fahrenheit', 'celsius')).toBeCloseTo(100);
      expect(Converter.convertTemperature(-40, 'fahrenheit', 'celsius')).toBeCloseTo(-40);
    });

    test('should convert fahrenheit to kelvin', () => {
      expect(Converter.convertTemperature(32, 'fahrenheit', 'kelvin')).toBeCloseTo(273.15);
      expect(Converter.convertTemperature(212, 'fahrenheit', 'kelvin')).toBeCloseTo(373.15);
    });

    test('should convert kelvin to celsius', () => {
      expect(Converter.convertTemperature(273.15, 'kelvin', 'celsius')).toBeCloseTo(0);
      expect(Converter.convertTemperature(373.15, 'kelvin', 'celsius')).toBeCloseTo(100);
      expect(Converter.convertTemperature(0, 'kelvin', 'celsius')).toBeCloseTo(-273.15);
    });

    test('should convert kelvin to fahrenheit', () => {
      expect(Converter.convertTemperature(273.15, 'kelvin', 'fahrenheit')).toBeCloseTo(32);
      expect(Converter.convertTemperature(373.15, 'kelvin', 'fahrenheit')).toBeCloseTo(212);
    });

    test('should return same value when units are the same', () => {
      expect(Converter.convertTemperature(100, 'celsius', 'celsius')).toBe(100);
      expect(Converter.convertTemperature(100, 'fahrenheit', 'fahrenheit')).toBe(100);
      expect(Converter.convertTemperature(100, 'kelvin', 'kelvin')).toBe(100);
    });

    test('should throw error for unsupported units', () => {
      expect(() => Converter.convertTemperature(100, 'celsius', 'invalid')).toThrow();
      expect(() => Converter.convertTemperature(100, 'invalid', 'celsius')).toThrow();
    });
  });

  describe('convertLength', () => {
    test('should convert between metric units', () => {
      expect(Converter.convertLength(1, 'meter', 'centimeter')).toBeCloseTo(100);
      expect(Converter.convertLength(1, 'meter', 'millimeter')).toBeCloseTo(1000);
      expect(Converter.convertLength(1, 'kilometer', 'meter')).toBeCloseTo(1000);
      expect(Converter.convertLength(100, 'centimeter', 'meter')).toBeCloseTo(1);
    });

    test('should convert between imperial units', () => {
      expect(Converter.convertLength(1, 'foot', 'inch')).toBeCloseTo(12);
      expect(Converter.convertLength(3, 'foot', 'yard')).toBeCloseTo(1);
      expect(Converter.convertLength(1, 'mile', 'foot')).toBeCloseTo(5280);
    });

    test('should convert between metric and imperial units', () => {
      expect(Converter.convertLength(1, 'meter', 'inch')).toBeCloseTo(39.3701);
      expect(Converter.convertLength(1, 'foot', 'meter')).toBeCloseTo(0.3048);
      expect(Converter.convertLength(1, 'kilometer', 'mile')).toBeCloseTo(0.621371);
    });

    test('should return same value when units are the same', () => {
      expect(Converter.convertLength(100, 'meter', 'meter')).toBe(100);
      expect(Converter.convertLength(100, 'foot', 'foot')).toBe(100);
    });

    test('should throw error for unsupported units', () => {
      expect(() => Converter.convertLength(100, 'meter', 'invalid')).toThrow();
      expect(() => Converter.convertLength(100, 'invalid', 'meter')).toThrow();
    });
  });

  describe('convertWeight', () => {
    test('should convert between metric units', () => {
      expect(Converter.convertWeight(1, 'kilogram', 'gram')).toBeCloseTo(1000);
      expect(Converter.convertWeight(1, 'kilogram', 'milligram')).toBeCloseTo(1000000);
      expect(Converter.convertWeight(1, 'ton', 'kilogram')).toBeCloseTo(1000);
      expect(Converter.convertWeight(1000, 'gram', 'kilogram')).toBeCloseTo(1);
    });

    test('should convert between imperial units', () => {
      expect(Converter.convertWeight(1, 'pound', 'ounce')).toBeCloseTo(16);
    });

    test('should convert between metric and imperial units', () => {
      expect(Converter.convertWeight(1, 'kilogram', 'pound')).toBeCloseTo(2.20462);
      expect(Converter.convertWeight(1, 'pound', 'kilogram')).toBeCloseTo(0.453592);
    });

    test('should return same value when units are the same', () => {
      expect(Converter.convertWeight(100, 'kilogram', 'kilogram')).toBe(100);
      expect(Converter.convertWeight(100, 'pound', 'pound')).toBe(100);
    });

    test('should throw error for unsupported units', () => {
      expect(() => Converter.convertWeight(100, 'kilogram', 'invalid')).toThrow();
      expect(() => Converter.convertWeight(100, 'invalid', 'kilogram')).toThrow();
    });
  });
});