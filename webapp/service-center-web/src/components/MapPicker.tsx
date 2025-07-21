'use client';

import { GoogleMap, LoadScript, Marker } from '@react-google-maps/api';
import { useState } from 'react';

const containerStyle = {
  width: '100%',
  height: '400px',
};

const center = { lat: 0, lng: 0 };

interface MapPickerProps {
  onLocationSelect: (location: { lat: number; lng: number }) => void;
}

export default function MapPicker({ onLocationSelect }: MapPickerProps) {
  const [position, setPosition] = useState(center);

  const onMapClick = (e: google.maps.MapMouseEvent) => {
    const lat = e.latLng?.lat() || 0;
    const lng = e.latLng?.lng() || 0;
    setPosition({ lat, lng });
    onLocationSelect({ lat, lng });
  };

  return (
    <LoadScript googleMapsApiKey={process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY!}>
      <GoogleMap
        mapContainerStyle={containerStyle}
        center={position}
        zoom={2}
        onClick={onMapClick}
      >
        <Marker position={position} />
      </GoogleMap>
    </LoadScript>
  );
}