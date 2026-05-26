<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::firstOrCreate(['email' => 'admin@example.com'], [
            'name'     => 'Administrateur',
            'phone'    => '1234567890',
            'password' => Hash::make('password'),
            'role'     => 'admin',
        ]);

        User::firstOrCreate(['email' => 'user@example.com'], [
            'name'     => 'Utilisateur Test',
            'phone'    => '0987654321',
            'password' => Hash::make('password'),
            'role'     => 'user',
        ]);
    }
}
