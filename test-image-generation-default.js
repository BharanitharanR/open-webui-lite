#!/usr/bin/env node
/**
 * Test script to verify that image generation is enabled by default
 * This script checks the default values in the frontend components
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('🧪 Testing Image Generation Default Settings');
console.log('=' .repeat(50));

// Check if the changes were applied correctly

// Check MessageInput.svelte
const messageInputPath = path.join(__dirname, 'src/lib/components/chat/MessageInput.svelte');
if (fs.existsSync(messageInputPath)) {
    const content = fs.readFileSync(messageInputPath, 'utf8');
    const hasDefaultTrue = content.includes('export let imageGenerationEnabled = true;');
    const hasShowButton = content.includes('$config?.features?.enable_image_generation');
    
    console.log('✅ MessageInput.svelte:');
    console.log(`   - Default value set to true: ${hasDefaultTrue ? 'YES' : 'NO'}`);
    console.log(`   - Button visibility logic updated: ${hasShowButton ? 'YES' : 'NO'}`);
} else {
    console.log('❌ MessageInput.svelte not found');
}

// Check Chat.svelte
const chatPath = path.join(__dirname, 'src/lib/components/chat/Chat.svelte');
if (fs.existsSync(chatPath)) {
    const content = fs.readFileSync(chatPath, 'utf8');
    const hasDefaultTrue = content.includes('let imageGenerationEnabled = true;');
    
    console.log('✅ Chat.svelte:');
    console.log(`   - Default value set to true: ${hasDefaultTrue ? 'YES' : 'NO'}`);
} else {
    console.log('❌ Chat.svelte not found');
}

console.log('\n📋 Summary:');
console.log('The image generation option should now be enabled by default in the chat screen.');
console.log('Users will see the image generation button automatically when:');
console.log('1. Starting a new chat');
console.log('2. The backend has image generation enabled');
console.log('3. The user has proper permissions');

console.log('\n🎯 To test:');
console.log('1. Start Open WebUI');
console.log('2. Go to a chat');
console.log('3. Look for the "Image" button in the input area');
console.log('4. It should be visible and enabled by default'); 