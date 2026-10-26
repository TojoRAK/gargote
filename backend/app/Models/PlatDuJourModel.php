<?php

namespace App\Models;

use CodeIgniter\Model;

class PlatDuJourModel extends Model
{
    protected $table = 'plat_du_jour';
    protected $primaryKey = 'date_jour';
    protected $returnType = 'array';
    protected $allowedFields = ['date_jour', 'id_plat'];

    // PostgreSQL renvoie les nombres sous forme de texte : on les convertit.
    protected array $casts = [
        'date_jour' => 'date',
        'id_plat' => 'int',
    ];

    public function aujourdHui(): ?array
    {
        return $this->select('plat_du_jour.date_jour, plat.*')
            ->join('plat', 'plat.id = plat_du_jour.id_plat')
            ->where('plat_du_jour.date_jour', date('Y-m-d'))
            ->first();
    }

    public function historique(): array
    {
        return $this->select('plat_du_jour.date_jour, plat.*')
            ->join('plat', 'plat.id = plat_du_jour.id_plat')
            ->where("plat_du_jour.date_jour >= CURRENT_DATE - 6'", null, false)
            ->orderBy('plat_du_jour.date_jour', 'DESC')
            ->findAll();
    }
    public function remplacerAujourdHui(int $idPlat): void
    {
        $sql = '
            INSERT INTO plat_du_jour (date_jour, id_plat)
            VALUES (CURRENT_DATE, ?)
            ON CONFLICT (date_jour)
            DO UPDATE SET id_plat = EXCLUDED.id_plat
            ';

        $this->db->query($sql, [$idPlat]);
    }
}
