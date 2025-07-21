'use client';

import { useState } from 'react';
import axios from 'axios';
import MapPicker from '@/components/MapPicker';

export default function Home() {
  const [name, setName] = useState('');
  const [location, setLocation] = useState({ lat: 0, lng: 0 });
  const [message, setMessage] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await axios.post('https://localhost:5001/api/servicecenters', {
        name,
        latitude: location.lat,
        longitude: location.lng,
      });
      setMessage('Service center registered successfully!');
      setName('');
      setLocation({ lat: 0, lng: 0 });
    } catch (error) {
      setMessage('Error registering service center.');
      console.error(error);
    }
  };

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Register Service Center</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium">Service Center Name</label>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="mt-1 p-2 w-full border rounded-md"
            required
          />
        </div>
        <div>
          <label className="block text-sm font-medium">Select Location</label>
          <MapPicker onLocationSelect={setLocation} />
          <p className="mt-2 text-sm">
            Selected: Lat: {location.lat.toFixed(4)}, Lng: {location.lng.toFixed(4)}
          </p>
        </div>
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600"
        >
          Register
        </button>
      </form>
      {message && <p className="mt-4 text-green-600">{message}</p>}
    </div>
  );
}