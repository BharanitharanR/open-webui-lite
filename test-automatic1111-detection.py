#!/usr/bin/env python3
"""
Test script for Automatic1111 detection
This script tests if Automatic1111 is running and accessible
"""

import requests
import sys

def test_automatic1111_detection():
    """Test Automatic1111 detection on common ports"""
    ports_to_test = [7086, 7860]
    
    print("🔍 Testing Automatic1111 detection...")
    print("=" * 40)
    
    for port in ports_to_test:
        url = f"http://localhost:{port}/sdapi/v1/options"
        print(f"Testing {url}...")
        
        try:
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                print(f"✅ Automatic1111 detected at http://localhost:{port}")
                print(f"   Status: {response.status_code}")
                
                # Try to get model info
                try:
                    models_response = requests.get(f"http://localhost:{port}/sdapi/v1/sd-models", timeout=5)
                    if models_response.status_code == 200:
                        models = models_response.json()
                        print(f"   Available models: {len(models)}")
                        if models:
                            print(f"   Current model: {models[0].get('title', 'Unknown')}")
                except Exception as e:
                    print(f"   Could not fetch models: {e}")
                
                return f"http://localhost:{port}"
            else:
                print(f"❌ HTTP {response.status_code} at {url}")
        except requests.exceptions.ConnectionError:
            print(f"❌ Connection refused at {url}")
        except requests.exceptions.Timeout:
            print(f"❌ Timeout at {url}")
        except Exception as e:
            print(f"❌ Error at {url}: {e}")
    
    print("\n❌ No Automatic1111 instance detected")
    print("\nTo start Automatic1111:")
    print("1. Install Automatic1111: https://github.com/AUTOMATIC1111/stable-diffusion-webui")
    print("2. Run with API enabled: python webui.py --api --listen --port 7086")
    print("3. Or use Docker: docker run -d -p 7086:7860 ghcr.io/neggles/sd-webui-docker:latest")
    
    return None

if __name__ == "__main__":
    result = test_automatic1111_detection()
    if result:
        print(f"\n🎉 Automatic1111 is ready at: {result}")
        print("Open WebUI will automatically detect and configure it!")
        sys.exit(0)
    else:
        print("\n💡 Automatic1111 not found. Please start it first.")
        sys.exit(1) 