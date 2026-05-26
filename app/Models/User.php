<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Maravel\Models\AuthenticatableBase;

class User extends AuthenticatableBase
{
    use HasFactory;

    protected $fillable = [
        'name',
        'email',
        'phone',
        'password',
        'role',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function getAbilityRulesAttribute(): array
    {
        return match ($this->role) {
            'admin' => [['subject' => ['all'], 'action' => ['manage']]],
            default => [
                ['subject' => ['User'], 'action' => ['read', 'create']],
                ['subject' => ['Auth'],   'action' => ['read']],
            ],
        };
    }
}
