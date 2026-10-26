<?php

namespace App\Controllers\Api;

use App\Exceptions\RegleMetierException;
use App\Services\PlatDuJourService;

class PlatDuJour extends ApiController
{
    public function index()
    {
        return $this->respond((new PlatDuJourService())->aujourdHui());
    }

    public function update()
    {
        $donnees = $this->donneesJson();
        $idPlat = $donnees['id_plat'] ?? null;

        if ($idPlat == null) {
            return $this->erreurValidation([
                'id_plat' => 'L’identifiant du plat est obligatoire et doit être un entier.',
            ]);
        }

        try {
            return $this->respond((new PlatDuJourService())->choisir((int) $idPlat));
        } catch (RegleMetierException $e) {
            return $this->erreurMetier($e);
        }
    }

    public function historique()
    {
        return $this->respond((new PlatDuJourService())->historique());
    }
}
