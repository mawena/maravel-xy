<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\PermissionController;
use App\Http\Controllers\API\RoleController;
use App\Http\Controllers\API\UserController;
use Illuminate\Support\Facades\Route;

Route::controller(AuthController::class)->group(function () {
    Route::post('auth/login', 'login')->name('auth.login');

    Route::middleware('auth:sanctum')->group(function () {
        Route::prefix('auth')->name('auth.')->group(function () {
            Route::get('data', 'data')->name('data');
            Route::delete('logout', 'logout')->name('logout');
        });

        // Toujours accessible, même si password_change_required = true
        Route::put('users/update-password', [UserController::class, 'updatePassword'])
            ->name('user.update-password');

        // Routes protégées par le middleware de statut de compte
        Route::middleware('account.status')->group(function () {
            Route::apiResource('users', UserController::class);
            Route::apiResource('roles', RoleController::class);
            Route::apiResource('permissions', PermissionController::class);
        });
    });
});
