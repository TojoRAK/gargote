<?php

namespace App\Services;

use App\Exceptions\RegleMetierException;
use App\Models\PlatDuJourModel;
use App\Models\PlatModel;

class PlatDuJourService
{
    public function aujourdHui(): ?array
    {
        return model(PlatDuJourModel::class)->aujourdHui();
    }

    public function historique(): array
    {
        return model(PlatDuJourModel::class)->historique();
    }

    /**
     * Choisit le plat du jour après vérification des règles métier.
     *
     * @throws RegleMetierException
     */
    public function choisir(int $idPlat): array
    {
        $plat = model(PlatModel::class)->find($idPlat);

        if ($plat === null) {
            throw new RegleMetierException('Ce plat n’existe pas.', [
                'id_plat' => 'Le plat demandé est introuvable.',
            ]);
        }

        if (! $plat['disponible']) {
            throw new RegleMetierException(
                $plat['nom'] . ' est épuisé : il ne peut pas être plat du jour.',
                [],
                409
            );
        }

        $platDuJour = model(PlatDuJourModel::class);
        $platDuJour->remplacerAujourdHui($idPlat);

        return $platDuJour->aujourdHui();
    }
}
