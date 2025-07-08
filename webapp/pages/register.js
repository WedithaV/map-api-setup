import { useState } from "react";
import { GoogleMap, Marker, useJsApiLoader } from "@react-google-maps/api";

const defaultCenter = { lat: 6.9271, lng: 79.8612 }; // Colombo

export default function RegisterPage() {
    const [name, setName] = useState("");
    const [markerPosition, setMarkerPosition] = useState(defaultCenter);

    const { isLoaded } = useJsApiLoader({
        googleMapsApiKey: "AIzaSyDrYWEZiKDquGuMbjT6zr0QjWlvl4U6aRA", // Replace this
    });

    const handleSubmit = async () => {
        const data = {
            name,
            latitude: markerPosition.lat,
            longitude: markerPosition.lng,
        };

        await fetch("http://localhost:5000/api/servicecenters", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data),
        });

        alert("Service center submitted!");
    };

    return isLoaded ? (
        <div style={{ padding: 20 }}>
            <h2>Register Service Center</h2>

            <input
                type="text"
                placeholder="Center Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
            />

            <br /><br />

            <div style={{ height: "400px", width: "100%" }}>
                <GoogleMap
                    center={markerPosition}
                    zoom={15}
                    mapContainerStyle={{ width: "100%", height: "100%" }}
                    onClick={(e) =>
                        setMarkerPosition({ lat: e.latLng.lat(), lng: e.latLng.lng() })
                    }
                >
                    <Marker position={markerPosition} />
                </GoogleMap>
            </div>

            <p>
                Selected Location: <br />
                Latitude: {markerPosition.lat} <br />
                Longitude: {markerPosition.lng}
            </p>

            <button onClick={handleSubmit}>Submit</button>
        </div>
    ) : (
        <div>Loading Map...</div>
    );
}
