#!/bin/bash

# Image Generation Connectivity Test Script
# This script helps diagnose image generation connectivity issues

echo "🔍 LLM-Forgex-Client Image Generation Diagnostic Tool"
echo "=================================================="

# Check environment variables
echo ""
echo "📋 Environment Variables Check:"
echo "--------------------------------"

ENABLE_IMAGE_GENERATION=${ENABLE_IMAGE_GENERATION:-"not set"}
IMAGE_GENERATION_ENGINE=${IMAGE_GENERATION_ENGINE:-"not set"}

echo "ENABLE_IMAGE_GENERATION: $ENABLE_IMAGE_GENERATION"
echo "IMAGE_GENERATION_ENGINE: $IMAGE_GENERATION_ENGINE"

# Check engine-specific variables
case $IMAGE_GENERATION_ENGINE in
    "openai")
        echo "IMAGES_OPENAI_API_KEY: ${IMAGES_OPENAI_API_KEY:-"not set"}"
        echo "IMAGES_OPENAI_API_BASE_URL: ${IMAGES_OPENAI_API_BASE_URL:-"not set"}"
        ;;
    "automatic1111")
        echo "AUTOMATIC1111_BASE_URL: ${AUTOMATIC1111_BASE_URL:-"not set"}"
        echo "AUTOMATIC1111_API_AUTH: ${AUTOMATIC1111_API_AUTH:-"not set"}"
        ;;
    "comfyui")
        echo "COMFYUI_BASE_URL: ${COMFYUI_BASE_URL:-"not set"}"
        echo "COMFYUI_API_KEY: ${COMFYUI_API_KEY:-"not set"}"
        ;;
    "gemini")
        echo "IMAGES_GEMINI_API_KEY: ${IMAGES_GEMINI_API_KEY:-"not set"}"
        echo "IMAGES_GEMINI_API_BASE_URL: ${IMAGES_GEMINI_API_BASE_URL:-"not set"}"
        ;;
    *)
        echo "No specific engine configured"
        ;;
esac

echo ""
echo "🔗 Connectivity Tests:"
echo "---------------------"

# Test OpenAI connectivity
if [ "$IMAGE_GENERATION_ENGINE" = "openai" ] && [ -n "$IMAGES_OPENAI_API_KEY" ]; then
    echo "Testing OpenAI API connectivity..."
    if curl -s -H "Authorization: Bearer $IMAGES_OPENAI_API_KEY" \
        "${IMAGES_OPENAI_API_BASE_URL:-https://api.openai.com/v1}/models" > /dev/null 2>&1; then
        echo "✅ OpenAI API is accessible"
    else
        echo "❌ OpenAI API is not accessible"
    fi
fi

# Test Automatic1111 connectivity
if [ "$IMAGE_GENERATION_ENGINE" = "automatic1111" ] && [ -n "$AUTOMATIC1111_BASE_URL" ]; then
    echo "Testing Automatic1111 connectivity..."
    if curl -s "$AUTOMATIC1111_BASE_URL/sdapi/v1/options" > /dev/null 2>&1; then
        echo "✅ Automatic1111 is accessible"
    else
        echo "❌ Automatic1111 is not accessible"
        echo "   Make sure Automatic1111 is running on $AUTOMATIC1111_BASE_URL"
    fi
fi

# Test ComfyUI connectivity
if [ "$IMAGE_GENERATION_ENGINE" = "comfyui" ] && [ -n "$COMFYUI_BASE_URL" ]; then
    echo "Testing ComfyUI connectivity..."
    if curl -s "$COMFYUI_BASE_URL/object_info" > /dev/null 2>&1; then
        echo "✅ ComfyUI is accessible"
    else
        echo "❌ ComfyUI is not accessible"
        echo "   Make sure ComfyUI is running on $COMFYUI_BASE_URL"
    fi
fi

# Test Gemini connectivity
if [ "$IMAGE_GENERATION_ENGINE" = "gemini" ] && [ -n "$IMAGES_GEMINI_API_KEY" ]; then
    echo "Testing Gemini API connectivity..."
    if curl -s -H "x-goog-api-key: $IMAGES_GEMINI_API_KEY" \
        "${IMAGES_GEMINI_API_BASE_URL:-https://generativelanguage.googleapis.com}/v1beta/models" > /dev/null 2>&1; then
        echo "✅ Gemini API is accessible"
    else
        echo "❌ Gemini API is not accessible"
    fi
fi

echo ""
echo "🐳 Docker Status (if applicable):"
echo "--------------------------------"

# Check if running in Docker
if [ -f /.dockerenv ]; then
    echo "✅ Running inside Docker container"
    
    # Test host.docker.internal connectivity
    if curl -s http://host.docker.internal:7860/sdapi/v1/options > /dev/null 2>&1; then
        echo "✅ host.docker.internal:7860 is accessible"
    else
        echo "❌ host.docker.internal:7860 is not accessible"
    fi
    
    if curl -s http://host.docker.internal:8188/object_info > /dev/null 2>&1; then
        echo "✅ host.docker.internal:8188 is accessible"
    else
        echo "❌ host.docker.internal:8188 is not accessible"
    fi
else
    echo "ℹ️  Running on host system"
fi

echo ""
echo "📝 Recommendations:"
echo "------------------"

if [ "$ENABLE_IMAGE_GENERATION" != "true" ]; then
    echo "1. Set ENABLE_IMAGE_GENERATION=true"
fi

if [ "$IMAGE_GENERATION_ENGINE" = "not set" ]; then
    echo "2. Choose an image generation engine:"
    echo "   - openai (easiest, requires API key)"
    echo "   - automatic1111 (local Stable Diffusion)"
    echo "   - comfyui (advanced Stable Diffusion)"
    echo "   - gemini (Google's Imagen)"
fi

case $IMAGE_GENERATION_ENGINE in
    "openai")
        if [ -z "$IMAGES_OPENAI_API_KEY" ]; then
            echo "3. Get an OpenAI API key from https://platform.openai.com/api-keys"
            echo "4. Set IMAGES_OPENAI_API_KEY=your-key"
        fi
        ;;
    "automatic1111")
        if [ -z "$AUTOMATIC1111_BASE_URL" ]; then
            echo "3. Set AUTOMATIC1111_BASE_URL=http://localhost:7860"
        fi
        echo "4. Start Automatic1111: docker run -d -p 7860:7860 ghcr.io/neggles/sd-webui-docker:latest"
        ;;
    "comfyui")
        if [ -z "$COMFYUI_BASE_URL" ]; then
            echo "3. Set COMFYUI_BASE_URL=http://localhost:8188"
        fi
        echo "4. Start ComfyUI: docker run -d -p 8188:8188 comfyui/comfyui"
        ;;
    "gemini")
        if [ -z "$IMAGES_GEMINI_API_KEY" ]; then
            echo "3. Get a Gemini API key from https://makersuite.google.com/app/apikey"
            echo "4. Set IMAGES_GEMINI_API_KEY=your-key"
        fi
        ;;
esac

echo ""
echo "🔧 Quick Fix Commands:"
echo "---------------------"

echo "# For OpenAI:"
echo "export ENABLE_IMAGE_GENERATION=true"
echo "export IMAGE_GENERATION_ENGINE=openai"
echo "export IMAGES_OPENAI_API_KEY='your-openai-key'"
echo ""

echo "# For Automatic1111:"
echo "docker run -d -p 7860:7860 ghcr.io/neggles/sd-webui-docker:latest"
echo "export ENABLE_IMAGE_GENERATION=true"
echo "export IMAGE_GENERATION_ENGINE=automatic1111"
echo "export AUTOMATIC1111_BASE_URL=http://localhost:7860"
echo ""

echo "# For ComfyUI:"
echo "docker run -d -p 8188:8188 comfyui/comfyui"
echo "export ENABLE_IMAGE_GENERATION=true"
echo "export IMAGE_GENERATION_ENGINE=comfyui"
echo "export COMFYUI_BASE_URL=http://localhost:8188"
echo ""

echo "📖 For more help, see: IMAGE_GENERATION_TROUBLESHOOTING.md" 