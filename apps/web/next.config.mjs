/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    transpilePackages: ['@microloan/shared', '@microloan/base-adapter', '@microloan/stacks-adapter'],
};

export default nextConfig;
