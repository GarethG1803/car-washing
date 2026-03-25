import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

@Entity('inventory_items')
export class InventoryItem extends BaseEntity {
  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  sku: string;

  @Column({ default: 0 })
  currentStock: number;

  @Column({ default: 10 })
  minimumStock: number;

  @Column({ nullable: true })
  unit: string;

  @Column({ type: 'float', default: 0 })
  unitPrice: number;

  @Column({ nullable: true })
  supplier: string;

  @Column({ nullable: true })
  category: string;

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ nullable: true })
  lastRestocked: Date;
}
